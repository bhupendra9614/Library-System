package com.bhupi.controller;

import java.util.HashSet;
import java.util.Set;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

import com.bhupi.service.Cart;

/** Har page me cartCount aur cartIds available kar deta hai (top bar ke count ke liye). */
@ControllerAdvice
public class CartAdvice {

    private final Cart cart;

    public CartAdvice(Cart cart) {
        this.cart = cart;
    }

    @ModelAttribute("cartCount")
    public int cartCount() {
        return cart.size();
    }

    @ModelAttribute("cartIds")
    public Set<Long> cartIds() {
        return new HashSet<>(cart.getBookIds());
    }
}