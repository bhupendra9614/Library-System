package com.bhupi.repository;

import com.bhupi.entity.BookIssue;
import com.bhupi.entity.IssueStatus;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface BookIssueRepository extends JpaRepository<BookIssue, Long> {

    List<BookIssue> findByMember_UsernameOrderByIssueDateDesc(String username);

    List<BookIssue> findAllByOrderByIssueDateDesc();

    long countByMember_UsernameAndStatus(String username, IssueStatus status);
}