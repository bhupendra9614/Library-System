package com.bhupi.service;

import com.bhupi.entity.Book;
import org.springframework.data.domain.Page;

import java.util.List;

public interface BookService {

    Book addBook(Book book);

    List<Book> getAllBooks();

    Page<Book> getBooks(int page, int size, String sortBy, String dir);

    Book getBookById(Long id);

    Book updateBook(Long id, Book book);

    void deleteBook(Long id);

    List<Book> searchBooks(String keyword);

    long countBooks();

    long countAvailable();
}