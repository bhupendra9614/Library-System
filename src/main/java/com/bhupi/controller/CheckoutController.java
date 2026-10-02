package com.bhupi.controller;

import com.bhupi.entity.Book;
import com.bhupi.entity.BookIssue;
import com.bhupi.entity.Payment;
import com.bhupi.exception.BookNotFoundException;
import com.bhupi.exception.BusinessException;
import com.bhupi.service.BookIssueService;
import com.bhupi.service.BookService;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;

@Controller
@RequestMapping("/checkout")
public class CheckoutController {

    private final BookService bookService;
    private final BookIssueService issueService;

    public CheckoutController(BookService bookService, BookIssueService issueService) {
        this.bookService = bookService;
        this.issueService = issueService;
    }

    // Step 1: checkout page (book summary + payment options)
    @GetMapping("/{bookId}")
    public String checkout(@PathVariable Long bookId,
                           Model model,
                           RedirectAttributes ra) {

        Book book = bookService.getBookById(bookId);

        if (!Boolean.TRUE.equals(book.getAvailable())) {
            ra.addFlashAttribute("error", "This book is not available right now.");
            return "redirect:/books/search";
        }

        model.addAttribute("book", book);
        model.addAttribute("fee", BookIssueService.ISSUE_FEE);
        model.addAttribute("loanDays", BookIssueService.LOAN_DAYS);
        model.addAttribute("dueDate", LocalDate.now().plusDays(BookIssueService.LOAN_DAYS));
        model.addAttribute("finePerDay", BookIssue.FINE_PER_DAY);
        return "checkout";
    }

    // Step 2: payment ke baad issue
    @PostMapping("/{bookId}/pay")
    public String pay(@PathVariable Long bookId,
                      @RequestParam String method,
                      Authentication auth,
                      RedirectAttributes ra) {
        try {
            BookIssue issue = issueService.issueWithPayment(bookId, auth.getName(), method);
            return "redirect:/checkout/success/" + issue.getId();
        } catch (BusinessException | BookNotFoundException e) {
            ra.addFlashAttribute("error", e.getMessage());
            return "redirect:/books/search";
        }
    }

    // Step 3: success + receipt
    @GetMapping("/success/{issueId}")
    public String success(@PathVariable Long issueId,
                          Authentication auth,
                          Model model) {

        Payment payment = issueService.getReceipt(issueId, auth.getName());

        model.addAttribute("payment", payment);
        model.addAttribute("issue", payment.getIssue());
        model.addAttribute("finePerDay", BookIssue.FINE_PER_DAY);
        return "payment-success";
    }
}