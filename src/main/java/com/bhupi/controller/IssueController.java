package com.bhupi.controller;

import com.bhupi.exception.BusinessException;
import com.bhupi.service.BookIssueService;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/issues")
public class IssueController {

    private final BookIssueService issueService;

    public IssueController(BookIssueService issueService) {
        this.issueService = issueService;
    }

    // NOTE: "/issues/issue/{bookId}" hata diya hai.
    // Ab issue sirf /checkout/** se hota hai, taaki payment skip na ho sake.

    @PostMapping("/return/{issueId}")
    public String returnBook(@PathVariable Long issueId,
                             Authentication auth,
                             RedirectAttributes ra) {

        boolean admin = auth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
        try {
            var issue = issueService.returnBook(issueId, auth.getName(), admin);
            String msg = "Book returned successfully.";
            if (issue.getFineAmount() != null && issue.getFineAmount() > 0) {
                msg += " Late fine: Rs " + issue.getFineAmount();
            }
            ra.addFlashAttribute("success", msg);
        } catch (BusinessException e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return admin ? "redirect:/issues/all" : "redirect:/issues/my";
    }

    @GetMapping("/my")
    public String myIssues(Authentication auth, Model model) {
        model.addAttribute("issues", issueService.getMyIssues(auth.getName()));
        model.addAttribute("pageTitle", "My Issued Books");
        model.addAttribute("adminView", false);
        return "issues";
    }

    @GetMapping("/all")
    public String allIssues(Model model) {
        model.addAttribute("issues", issueService.getAllIssues());
        model.addAttribute("pageTitle", "All Issued Books");
        model.addAttribute("adminView", true);
        return "issues";
    }
}