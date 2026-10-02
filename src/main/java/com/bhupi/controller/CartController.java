package com.bhupi.controller;

import java.net.URI;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.bhupi.entity.Book;
import com.bhupi.entity.BookIssue;
import com.bhupi.entity.Payment;
import com.bhupi.exception.BookNotFoundException;
import com.bhupi.exception.BusinessException;
import com.bhupi.service.BookIssueService;
import com.bhupi.service.BookService;
import com.bhupi.service.Cart;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/cart")
public class CartController {

    private final Cart cart;
    private final BookService bookService;
    private final BookIssueService issueService;

    public CartController(Cart cart, BookService bookService, BookIssueService issueService) {
        this.cart = cart;
        this.bookService = bookService;
        this.issueService = issueService;
    }

    // Cart page: books + payment
    @GetMapping
    public String view(Authentication auth, Model model) {
        List<Book> items = new ArrayList<>();
        for (Long id : new ArrayList<>(cart.getBookIds())) {
            try {
                Book b = bookService.getBookById(id);
                if (Boolean.TRUE.equals(b.getAvailable())) {
                    items.add(b);
                } else {
                    cart.remove(id);      // kisi aur ne issue kar li
                }
            } catch (BookNotFoundException e) {
                cart.remove(id);
            }
        }
        long active = issueService.countActive(auth.getName());

        model.addAttribute("items", items);
        model.addAttribute("count", items.size());
        model.addAttribute("fee", BookIssueService.ISSUE_FEE);
        model.addAttribute("total", items.size() * BookIssueService.ISSUE_FEE);
        model.addAttribute("activeCount", active);
        model.addAttribute("maxActive", BookIssueService.MAX_ACTIVE_ISSUES);
        model.addAttribute("slotsLeft", BookIssueService.MAX_ACTIVE_ISSUES - active);
        model.addAttribute("loanDays", BookIssueService.LOAN_DAYS);
        model.addAttribute("dueDate", LocalDate.now().plusDays(BookIssueService.LOAN_DAYS));
        model.addAttribute("finePerDay", BookIssue.FINE_PER_DAY);
        return "cart";
    }

    /** Normal form (JS band ho tab bhi chalta hai). */
    @PostMapping("/add/{bookId}")
    public String add(@PathVariable Long bookId, Authentication auth,
                      RedirectAttributes ra, HttpServletRequest request) {
        try {
            ra.addFlashAttribute("success", tryAdd(bookId, auth.getName()));
        } catch (BusinessException | BookNotFoundException e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:" + backTo(request);
    }

    /** AJAX: page reload nahi hota, scroll upar nahi jata. */
    @PostMapping(value = "/api/add/{bookId}", produces = "application/json")
    @ResponseBody
    public Map<String, Object> addAjax(@PathVariable Long bookId, Authentication auth) {
        Map<String, Object> res = new HashMap<>();
        try {
            res.put("message", tryAdd(bookId, auth.getName()));
            res.put("ok", true);
        } catch (BusinessException | BookNotFoundException e) {
            res.put("message", e.getMessage());
            res.put("ok", false);
        }
        res.put("count", cart.size());
        return res;
    }

    private String tryAdd(Long bookId, String username) {
        Book book = bookService.getBookById(bookId);
        if (!Boolean.TRUE.equals(book.getAvailable())) {
            throw new BusinessException("\"" + book.getTitle() + "\" is not available right now.");
        }
        if (cart.contains(bookId)) {
            throw new BusinessException("\"" + book.getTitle() + "\" is already in your cart.");
        }
        long active = issueService.countActive(username);
        if (active + cart.size() >= BookIssueService.MAX_ACTIVE_ISSUES) {
            throw new BusinessException("You can hold at most " + BookIssueService.MAX_ACTIVE_ISSUES
                    + " books at a time (" + active + " issued, " + cart.size() + " in cart).");
        }
        cart.add(bookId);
        return "\"" + book.getTitle() + "\" added to your cart.";
    }

    @PostMapping("/remove/{bookId}")
    public String remove(@PathVariable Long bookId) {
        cart.remove(bookId);
        return "redirect:/cart";
    }

    // Ek payment me cart ki saari books issue
    @PostMapping("/pay")
    public String pay(@RequestParam String method, Authentication auth, RedirectAttributes ra) {
        try {
            List<BookIssue> issues = issueService.issueCartWithPayment(
                    new ArrayList<>(cart.getBookIds()), auth.getName(), method);
            cart.clear();
            String ids = issues.stream().map(i -> String.valueOf(i.getId()))
                    .collect(Collectors.joining(","));
            return "redirect:/cart/success?ids=" + ids;
        } catch (BusinessException | BookNotFoundException e) {
            ra.addFlashAttribute("error", e.getMessage());
            return "redirect:/cart";
        }
    }

    @GetMapping("/success")
    public String success(@RequestParam String ids, Authentication auth, Model model) {
        List<Payment> payments = new ArrayList<>();
        for (String s : ids.split(",")) {
            try {
                payments.add(issueService.getReceipt(Long.parseLong(s.trim()), auth.getName()));
            } catch (NumberFormatException | BusinessException ignored) {
                // galat ya doosre ka id: chhod do
            }
        }
        if (payments.isEmpty()) {
            return "redirect:/issues/my";
        }
        model.addAttribute("payments", payments);
        model.addAttribute("total", payments.size() * BookIssueService.ISSUE_FEE);
        model.addAttribute("finePerDay", BookIssue.FINE_PER_DAY);
        return "cart-success";
    }

    /** Add-to-cart ke baad usi page par wapas (sirf apni site ka path, open redirect nahi). */
    private String backTo(HttpServletRequest request) {
        String ref = request.getHeader("Referer");
        if (ref != null) {
            try {
                URI u = URI.create(ref);
                if (request.getServerName().equals(u.getHost())) {
                    String path = u.getRawPath() == null ? "" : u.getRawPath();
                    String ctx = request.getContextPath();
                    if (!ctx.isEmpty() && path.startsWith(ctx)) {
                        path = path.substring(ctx.length());
                    }
                    if (path.startsWith("/") && !path.startsWith("//") && !path.startsWith("/cart")) {
                        return path + (u.getRawQuery() != null ? "?" + u.getRawQuery() : "");
                    }
                }
            } catch (Exception ignored) {
                // fallback neeche
            }
        }
        return "/explore";
    }
}