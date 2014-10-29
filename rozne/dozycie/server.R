## server.r
library(shiny)

daneM <- read.table("http://tofesi.mimuw.edu.pl/~cogito/smarterpoland/emerytura/tablicaTrwaniaZyciaM.txt",dec=",",row.names=1)
colnames(daneM) = c("dozywajacych","p.zgonu","l.zmarlych","l.w.wieku","l.skumulowana","dalszetrwanie")
daneK <- read.table("http://tofesi.mimuw.edu.pl/~cogito/smarterpoland/emerytura/tablicaTrwaniaZyciaK.txt",dec=",",row.names=1)
colnames(daneK) = c("dozywajacych","p.zgonu","l.zmarlych","l.w.wieku","l.skumulowana","dalszetrwanie")

shinyServer(function(input, output) {
  
  output$attrition <- renderPlot({
    
    mojWiek <- input$mojWiek
    cutoff <- input$cutoff
    
    
    proc <- pmin(daneM[,1]/daneM[mojWiek,1], 1)
    proc2 <- pmin(daneK[,1]/daneK[mojWiek,1], 1)
    
    plot(proc, yaxt="n", yaxs="i", xaxs="i", ylim=c(0,100), xlim=c(0,100), ylab="", xlab="wiek",type="n",main=paste("Prawdopodobienstwa dozycia dla osób w wieku ", mojWiek," lat"))
    axis(2, at=seq(0,100,10), labels=paste(seq(0,100,10), "%",sep=""), las=1)
    axis(1, at=seq(0,100,10))
    abline(h=seq(0,100,10), col="grey90")
    abline(v=seq(0,100,10), col="grey90")
    par(xpd=NA)
    points(0:100, proc*100,type="o", pch=19, cex=0.5, col="blue", lwd=2)
    points(0:100, proc2*100,type="o", pch=19, cex=0.5, col="pink3", lwd=2)
    par(xpd=F)
    
    abline(h=cutoff*100, col="black", lwd=2, lty=3)
    abline(v=max(which(proc>cutoff)) , col="black", lwd=2, lty=3)
    abline(v=max(which(proc2>cutoff)) , col="black", lwd=2, lty=3)
    
    
  })
})

