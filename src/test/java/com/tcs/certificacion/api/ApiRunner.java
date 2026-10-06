package com.tcs.certificacion.api;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class ApiRunner {

    @Test
    void testApi() {
        Results results = Runner.path("classpath:features/gestion_usuarios.feature")
                .outputJunitXml(true)
                .outputHtmlReport(true)
                .parallel(1);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}

