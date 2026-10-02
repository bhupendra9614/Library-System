package com.bhupi.entity;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "payments")
public class Payment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Har issue ke liye ek payment
    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "issue_id", nullable = false, unique = true)
    private BookIssue issue;

    @Column(nullable = false)
    private Double amount;

    @Column(nullable = false, length = 20)
    private String method;          // UPI / CARD / NETBANKING

    @Column(name = "transaction_id", nullable = false, unique = true, length = 30)
    private String transactionId;

    @Column(nullable = false, length = 20)
    private String status;          // SUCCESS

    @Column(name = "paid_at", nullable = false)
    private LocalDateTime paidAt;

    public Payment() {}

    @PrePersist
    protected void onCreate() {
        if (paidAt == null) {
            paidAt = LocalDateTime.now();
        }
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public BookIssue getIssue() { return issue; }
    public void setIssue(BookIssue issue) { this.issue = issue; }
    public Double getAmount() { return amount; }
    public void setAmount(Double amount) { this.amount = amount; }
    public String getMethod() { return method; }
    public void setMethod(String method) { this.method = method; }
    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getPaidAt() { return paidAt; }
    public void setPaidAt(LocalDateTime paidAt) { this.paidAt = paidAt; }
}