package com.bhupi.controller;

import com.bhupi.entity.Book;
import com.bhupi.exception.DuplicateIsbnException;
import com.bhupi.service.BookService;

import jakarta.validation.Valid;

import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Set;

@Controller
@RequestMapping("/books")
public class BookController {

    private static final Set<String> SORT_FIELDS =
            Set.of("id", "title", "author", "category", "price", "available");

    private final BookService bookService;

    public BookController(BookService bookService) {
        this.bookService = bookService;
    }

    // ---------- helpers ----------

    private String cleanSort(String sortBy) {
        return SORT_FIELDS.contains(sortBy) ? sortBy : "id";
    }

    private String cleanDir(String dir) {
        return "desc".equalsIgnoreCase(dir) ? "desc" : "asc";
    }

    private void setPaging(Model model, Page<Book> p, String sortBy, String dir) {
        model.addAttribute("books", p.getContent());
        model.addAttribute("currentPage", p.getNumber());
        model.addAttribute("totalPages", p.getTotalPages());
        model.addAttribute("totalItems", p.getTotalElements());
        model.addAttribute("size", p.getSize());
        model.addAttribute("sortBy", sortBy);
        model.addAttribute("dir", dir);
        model.addAttribute("reverseDir", "asc".equals(dir) ? "desc" : "asc");
    }

    private List<String> messages(BindingResult result) {
        return result.getAllErrors().stream()
                .map(e -> e.getDefaultMessage())
                .toList();
    }

    // ---------- /books -> ab search page hi browse page hai ----------

    @GetMapping
    public String getAllBooks() {
        return "redirect:/books/search";
    }

    // ---------- manage (manage-books.jsp) ----------

    @GetMapping("/manage")
    public String manageBooks(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "id") String sortBy,
            @RequestParam(defaultValue = "asc") String dir,
            Model model) {

        sortBy = cleanSort(sortBy);
        dir = cleanDir(dir);

        setPaging(model, bookService.getBooks(page, size, sortBy, dir), sortBy, dir);

        long total = bookService.countBooks();
        long available = bookService.countAvailable();
        model.addAttribute("totalBooks", total);
        model.addAttribute("availableBooks", available);
        model.addAttribute("unavailableBooks", total - available);

        return "manage-books";
    }

    // ---------- add ----------

    @GetMapping("/add")
    public String showAddBookForm(Model model) {
        model.addAttribute("book", new Book());
        return "add-book";
    }

    @PostMapping("/save")
    public String saveBook(@Valid @ModelAttribute("book") Book book,
                           BindingResult result,
                           Model model,
                           RedirectAttributes ra) {

        if (result.hasErrors()) {
            model.addAttribute("errorMessages", messages(result));
            return "add-book";
        }

        try {
            bookService.addBook(book);
        } catch (DuplicateIsbnException e) {
            model.addAttribute("errorMessages", List.of(e.getMessage()));
            return "add-book";
        }

        // Admin isi page par rahega: popup dikhega, form khali hoga, agli book add kar sakta hai
        ra.addFlashAttribute("success", book.getTitle());
        return "redirect:/books/add";
    }

    // ---------- search + browse (search-book.jsp) ----------

    @GetMapping("/search")
    public String searchBooks(
            @RequestParam(value = "keyword", required = false) String keyword,
            Model model) {

        String kw = keyword == null ? "" : keyword.trim();

        List<Book> books = kw.isEmpty()
                ? bookService.getAllBooks()
                : bookService.searchBooks(kw);

        model.addAttribute("books", books);
        model.addAttribute("keyword", kw);
        model.addAttribute("searched", true);
        return "search-book";
    }

    // ---------- details / edit / update / delete ----------

    @GetMapping("/{id}")
    public String getBookById(@PathVariable Long id, Model model) {
        model.addAttribute("book", bookService.getBookById(id));
        return "book-details";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        model.addAttribute("book", bookService.getBookById(id));
        return "edit-book";
    }

    @PostMapping("/update/{id}")
    public String updateBook(@PathVariable Long id,
                             @Valid @ModelAttribute("book") Book book,
                             BindingResult result,
                             Model model) {

        book.setId(id);

        if (result.hasErrors()) {
            model.addAttribute("errorMessages", messages(result));
            return "edit-book";
        }

        try {
            bookService.updateBook(id, book);
        } catch (DuplicateIsbnException e) {
            model.addAttribute("errorMessages", List.of(e.getMessage()));
            return "edit-book";
        }

        return "redirect:/books/manage";
    }

    @PostMapping("/delete/{id}")
    public String deleteBook(@PathVariable Long id) {
        bookService.deleteBook(id);
        return "redirect:/books/manage";
    }
}