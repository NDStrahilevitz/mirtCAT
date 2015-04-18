context('extra')

test_that('extra', {
    
    mod <- mirt(Science, 1, TOL = NaN, verbose=FALSE) 
    response <- c(0, 1, 2, 3)
    
    expect_error(mirtCAT(mo=mod, local_pattern = response), 
                 "For item 1, responses must be between 1 and 4. Please fix.")
    
    set.seed(1234)
    nitems <- 50
    itemnames <- paste0('Item.', 1:nitems)
    a <- matrix(rlnorm(nitems, .2, .3))
    d <- matrix(rnorm(nitems))
    
    # alternatively, define mo from population values (not run)
    pars <- data.frame(a1=a, d=d)
    mod2 <- generate.mirt_object(pars, itemtype='2PL')
    
    # simple math items
    questions <- answers <- character(nitems)
    choices <- matrix(NA, nitems, 5)
    spacing <- floor(d - min(d)) + 1 #easier items have more variation in the options
    
    for(i in 1:nitems){
        n1 <- sample(1:50, 1)
        n2 <- sample(51:100, 1)
        ans <- n1 + n2
        questions[i] <- paste0(n1, ' + ', n2, ' = ?')
        answers[i] <- as.character(ans)
        ch <- ans + sample(c(-5:-1, 1:5) * spacing[i,], 5)
        ch[sample(1:5, 1)] <- ans
        choices[i, ] <- as.character(ch)
    }
    
    df <- data.frame(Question=questions, Option=choices, 
                                  Type = 'radio', stringsAsFactors = FALSE)
    CATdesign <- mirtCAT(df, mod2, criteria = 'MI', design_elements = TRUE)
    expect_equal(1, findNextItem(CATdesign))
    CATdesign <- updateDesign(CATdesign, items = c(1, 10), responses = c(1, 1), Theta = 0.5)
    expect_equal(20, findNextItem(CATdesign))
    
})