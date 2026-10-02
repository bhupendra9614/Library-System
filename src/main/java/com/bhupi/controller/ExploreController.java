package com.bhupi.controller;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.bhupi.entity.Book;
import com.bhupi.repository.BookRepository;

@Controller
public class ExploreController {

    private final BookRepository bookRepository;

    public ExploreController(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    @GetMapping("/explore")
    public String explore(Model model) {
        Map<String, List<Book>> categories = new LinkedHashMap<>();

        // Shelf 1: jo books abhi issue ho sakti hain
        List<Book> all = bookRepository.findAll();
        List<Book> availableNow = new ArrayList<>();
        for (Book b : all) {
            if (Boolean.TRUE.equals(b.getAvailable())) availableNow.add(b);
        }
        if (!availableNow.isEmpty()) categories.put("Available Now", availableNow);

        // Baaki shelves: category ke hisaab se
        Map<String, List<Book>> byCategory = new LinkedHashMap<>();
        for (Book b : all) {
            String cat = (b.getCategory() == null || b.getCategory().isBlank())
                    ? "General" : b.getCategory();
            byCategory.computeIfAbsent(cat, k -> new ArrayList<>()).add(b);
        }
        categories.putAll(byCategory);

        model.addAttribute("categories", categories);

        // "Around the Library" stats
        int total = all.size();
        int available = availableNow.size();
        int issued = total - available;
        model.addAttribute("totalBooks", total);
        model.addAttribute("availableBooks", available);
        model.addAttribute("issuedBooks", issued);
        model.addAttribute("categoryCount", byCategory.size());
        model.addAttribute("availablePct", total == 0 ? 0 : available * 100 / total);
        model.addAttribute("issuedPct", total == 0 ? 0 : issued * 100 / total);
        return "explore";   // /WEB-INF/pages/explore.jsp
    }
}