package com.bhupi.service;

import com.bhupi.entity.Book;
import com.bhupi.exception.BookNotFoundException;
import com.bhupi.exception.BusinessException;
import com.bhupi.exception.DuplicateIsbnException;
import com.bhupi.repository.BookRepository;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class BookServiceImpl implements BookService {

    private final BookRepository bookRepository;

    public BookServiceImpl(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    @Override
    @Transactional
    public Book addBook(Book book) {
        if (bookRepository.existsByIsbn(book.getIsbn())) {
            throw new DuplicateIsbnException(book.getIsbn());
        }
        return bookRepository.save(book);
    }

    @Override
    public List<Book> getAllBooks() {
        return bookRepository.findAll();
    }

    @Override
    public Page<Book> getBooks(int page, int size, String sortBy, String dir) {
        int safePage = Math.max(page, 0);
        int safeSize = Math.min(Math.max(size, 1), 50);

        Sort sort = "desc".equalsIgnoreCase(dir)
                ? Sort.by(sortBy).descending()
                : Sort.by(sortBy).ascending();

        return bookRepository.findAll(PageRequest.of(safePage, safeSize, sort));
    }

    @Override
    public Book getBookById(Long id) {
        return bookRepository.findById(id)
                .orElseThrow(() -> new BookNotFoundException(id));
    }

    @Override
    @Transactional
    public Book updateBook(Long id, Book book) {
        Book existing = getBookById(id);

        if (bookRepository.existsByIsbnAndIdNot(book.getIsbn(), id)) {
            throw new DuplicateIsbnException(book.getIsbn());
        }

        existing.setTitle(book.getTitle());
        existing.setAuthor(book.getAuthor());
        existing.setIsbn(book.getIsbn());
        existing.setCategory(book.getCategory());
        existing.setPrice(book.getPrice());
        existing.setAvailable(book.getAvailable() == null ? Boolean.TRUE : book.getAvailable());

        return bookRepository.save(existing);
    }

    @Override
    @Transactional
    public void deleteBook(Long id) {
        Book existing = getBookById(id);
        try {
            bookRepository.delete(existing);
            bookRepository.flush();
        } catch (DataIntegrityViolationException e) {
            // Step 4 ke baad: issue history wali book delete nahi hogi
            throw new BusinessException("This book has issue history and cannot be deleted.");
        }
    }

    @Override
    public List<Book> searchBooks(String keyword) {
        return bookRepository
                .findByTitleContainingIgnoreCaseOrAuthorContainingIgnoreCase(keyword, keyword);
    }

    @Override
    public long countBooks() {
        return bookRepository.count();
    }

    @Override
    public long countAvailable() {
        return bookRepository.countByAvailable(true);
    }
}