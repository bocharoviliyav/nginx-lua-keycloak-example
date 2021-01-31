package io.github.bocharoviliyav.nginxconsumer;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * The Nginx consumer application class.
 */
@SpringBootApplication
public class NginxConsumerApplication {

    /**
     * The entry point of application.
     *
     * @param args the input arguments
     */
    public static void main(final String[] args) {
        SpringApplication.run(NginxConsumerApplication.class, args);
    }

}
