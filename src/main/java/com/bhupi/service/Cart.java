package com.bhupi.service;

import java.io.Serializable;
import java.util.LinkedHashSet;
import java.util.Set;

import org.springframework.stereotype.Component;
import org.springframework.web.context.annotation.SessionScope;

/** Har user ke session ka cart: sirf book ids rakhta hai. */
@Component
@SessionScope
public class Cart implements Serializable {

    private static final long serialVersionUID = 1L;

    private final Set<Long> bookIds = new LinkedHashSet<>();

    public Set<Long> getBookIds() { return bookIds; }
    public boolean contains(Long id) { return bookIds.contains(id); }
    public boolean add(Long id) { return bookIds.add(id); }
    public boolean remove(Long id) { return bookIds.remove(id); }
    public void clear() { bookIds.clear(); }
    public int size() { return bookIds.size(); }
}