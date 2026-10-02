package com.bhupi.controller;

import com.bhupi.entity.AppUser;
import com.bhupi.repository.UserRepository;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class AuthController {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public AuthController(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/register")
    public String registerForm() {
        return "register";
    }

    @PostMapping("/register")
    public String register(@RequestParam String fullName,
                           @RequestParam String phone,
                           @RequestParam String username,
                           @RequestParam String password,
                           RedirectAttributes ra) {

        fullName = fullName.trim();
        phone = phone.trim();
        username = username.trim();

        if (fullName.length() < 2 || fullName.length() > 100) {
            ra.addFlashAttribute("error", "Please enter your full name.");
            return "redirect:/register";
        }
        // Indian mobile number: 10 digits, starts with 6-9
        if (!phone.matches("^[6-9][0-9]{9}$")) {
            ra.addFlashAttribute("error", "Enter a valid 10 digit mobile number.");
            return "redirect:/register";
        }
        if (username.length() < 3 || password.length() < 6) {
            ra.addFlashAttribute("error", "Username min 3 and password min 6 characters required.");
            return "redirect:/register";
        }
        if (userRepository.existsByUsername(username)) {
            ra.addFlashAttribute("error", "Username already taken.");
            return "redirect:/register";
        }

        userRepository.save(new AppUser(username, passwordEncoder.encode(password), "MEMBER", fullName, phone));

        ra.addFlashAttribute("success", "Account created. Please login.");
        return "redirect:/login";
    }
}