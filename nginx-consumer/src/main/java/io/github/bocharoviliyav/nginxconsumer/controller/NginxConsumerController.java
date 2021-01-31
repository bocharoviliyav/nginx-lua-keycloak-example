package io.github.bocharoviliyav.nginxconsumer.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * The Nginx consumer controller.
 */
@RestController
@RequestMapping("")
public class NginxConsumerController {

    /**
     * Get endpoint that print authorization header.
     *
     * @param header request header
     * @return ok response
     */
    @GetMapping("/out")
    public ResponseEntity<String> printAuthorizationHeader(
            @RequestHeader("Authorization")
            final String header) {
        System.out.println(header);

        return ResponseEntity.ok("Nginx works correctly");
    }
}
