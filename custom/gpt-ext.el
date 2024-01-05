(gptel-request
 "What is your name"                                
 :callback (lambda (response info) (if (not response) (message "Error") (print response))))
