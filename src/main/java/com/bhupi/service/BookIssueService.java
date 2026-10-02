package com.bhupi.service;

import com.bhupi.entity.*;
import com.bhupi.exception.BookNotFoundException;
import com.bhupi.exception.BusinessException;
import com.bhupi.repository.BookIssueRepository;
import com.bhupi.repository.BookRepository;
import com.bhupi.repository.PaymentRepository;
import com.bhupi.repository.UserRepository;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;

@Service
public class BookIssueService {

    public static final int LOAN_DAYS = 14;
    public static final int MAX_ACTIVE_ISSUES = 3;
    public static final double ISSUE_FEE = 20.0;      // har issue par flat fee (badal sakte ho)

    private static final Set<String> PAYMENT_METHODS = Set.of("UPI", "CARD", "NETBANKING");

    private final BookIssueRepository issueRepository;
    private final BookRepository bookRepository;
    private final UserRepository userRepository;
    private final PaymentRepository paymentRepository;

    public BookIssueService(BookIssueRepository issueRepository,
                            BookRepository bookRepository,
                            UserRepository userRepository,
                            PaymentRepository paymentRepository) {
        this.issueRepository = issueRepository;
        this.bookRepository = bookRepository;
        this.userRepository = userRepository;
        this.paymentRepository = paymentRepository;
    }

    /** Member ki abhi kitni books issued hain. */
    public long countActive(String username) {
        return issueRepository.countByMember_UsernameAndStatus(username, IssueStatus.ISSUED);
    }

    /**
     * Checkout: payment + issue ek hi transaction me.
     * Payment fail ya koi rule fail ho to issue bhi save nahi hota.
     */
    @Transactional
    public BookIssue issueWithPayment(Long bookId, String username, String method) {

        String m = normalizeMethod(method);

        BookIssue issue = issueBook(bookId, username);

        Payment payment = newPayment(issue, m, newTxnId());
        paymentRepository.save(payment);

        return issue;
    }

    /**
     * Cart checkout: ek payment me saari books issue.
     * Koi bhi book ya rule fail ho to poora checkout rollback ho jata hai.
     */
    @Transactional
    public List<BookIssue> issueCartWithPayment(List<Long> bookIds, String username, String method) {

        if (bookIds == null || bookIds.isEmpty()) {
            throw new BusinessException("Your cart is empty.");
        }
        String m = normalizeMethod(method);

        long active = countActive(username);
        if (active + bookIds.size() > MAX_ACTIVE_ISSUES) {
            throw new BusinessException("You can hold at most " + MAX_ACTIVE_ISSUES
                    + " books at a time. You already have " + active + " issued.");
        }

        // pehle sab books check karo, taaki saaf message mile
        for (Long id : bookIds) {
            Book b = bookRepository.findById(id).orElseThrow(() -> new BookNotFoundException(id));
            if (!Boolean.TRUE.equals(b.getAvailable())) {
                throw new BusinessException("\"" + b.getTitle() + "\" is no longer available. Remove it from the cart.");
            }
        }

        String batch = newTxnId();
        List<BookIssue> issues = new ArrayList<>();
        int n = 1;
        for (Long id : bookIds) {
            BookIssue issue = issueBook(id, username);
            paymentRepository.save(newPayment(issue, m, batch + "-" + n));
            issues.add(issue);
            n++;
        }
        return issues;
    }

    @Transactional
    public BookIssue issueBook(Long bookId, String username) {

        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new BookNotFoundException(bookId));

        // Issue sirf tab, jab book available ho. Return ke baad dobara issue ho sakti hai.
        if (!Boolean.TRUE.equals(book.getAvailable())) {
            throw new BusinessException("This book is not available right now.");
        }

        AppUser member = userRepository.findByUsername(username)
                .orElseThrow(() -> new BusinessException("User not found."));

        long active = issueRepository.countByMember_UsernameAndStatus(username, IssueStatus.ISSUED);
        if (active >= MAX_ACTIVE_ISSUES) {
            throw new BusinessException("You can issue at most " + MAX_ACTIVE_ISSUES + " books at a time.");
        }

        LocalDate today = LocalDate.now();

        BookIssue issue = new BookIssue();
        issue.setBook(book);
        issue.setMember(member);
        issue.setIssueDate(today);
        issue.setDueDate(today.plusDays(LOAN_DAYS));
        issue.setStatus(IssueStatus.ISSUED);

        book.setAvailable(false);
        bookRepository.save(book);

        return issueRepository.save(issue);
    }

    @Transactional
    public BookIssue returnBook(Long issueId, String username, boolean isAdmin) {

        BookIssue issue = issueRepository.findById(issueId)
                .orElseThrow(() -> new BusinessException("Issue record not found."));

        if (!isAdmin && !issue.getMember().getUsername().equals(username)) {
            throw new BusinessException("You can only return your own books.");
        }
        if (issue.getStatus() == IssueStatus.RETURNED) {
            throw new BusinessException("This book is already returned.");
        }

        LocalDate today = LocalDate.now();
        issue.setReturnDate(today);
        issue.setFineAmount(BookIssue.calculateFine(issue.getDueDate(), today));
        issue.setStatus(IssueStatus.RETURNED);

        Book book = issue.getBook();
        book.setAvailable(true);
        bookRepository.save(book);

        return issueRepository.save(issue);
    }

    /** Receipt sirf usi member ko dikhegi jisne payment ki. */
    public Payment getReceipt(Long issueId, String username) {
        Payment payment = paymentRepository.findByIssue_Id(issueId)
                .orElseThrow(() -> new BusinessException("Receipt not found."));

        if (!payment.getIssue().getMember().getUsername().equals(username)) {
            throw new BusinessException("Receipt not found.");
        }
        return payment;
    }

    public List<BookIssue> getMyIssues(String username) {
        return issueRepository.findByMember_UsernameOrderByIssueDateDesc(username);
    }

    public List<BookIssue> getAllIssues() {
        return issueRepository.findAllByOrderByIssueDateDesc();
    }

    // ---------- helpers ----------

    private String normalizeMethod(String method) {
        String m = method == null ? "" : method.trim().toUpperCase(Locale.ROOT);
        if (!PAYMENT_METHODS.contains(m)) {
            throw new BusinessException("Please select a valid payment method.");
        }
        return m;
    }

    private String newTxnId() {
        return "TXN" + UUID.randomUUID().toString().replace("-", "")
                .substring(0, 12).toUpperCase(Locale.ROOT);
    }

    private Payment newPayment(BookIssue issue, String method, String txnId) {
        Payment payment = new Payment();
        payment.setIssue(issue);
        payment.setAmount(ISSUE_FEE);
        payment.setMethod(method);
        payment.setStatus("SUCCESS");
        payment.setTransactionId(txnId);
        return payment;
    }
}