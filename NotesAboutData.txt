So Rizi told me these things:
1. The values in the cells are the log2 transform of the gene counts. So to get back counts you should just do 2^(value).
2. The reads are mapped to GeneIDs. One gene might have multiple geneIDs but each geneID is associated with only one gene. This is because there might be multiple copies of the same gene.
These copies might be slightly different from each other. You should disscuss with Wei whether you should merge these genes or not!
3. The genes rizi has given me are only protein coding genes. There are way more genes then that in the cell. Wow, this is interesting I did not know humans had so many genes. I have to check this dude.
 I always used to hear that there are 20000-25000 protein coding genes in humans. This is really surprising. I think I should discuss this.
4. Also disscuss if we want to get other kinds of genes as well. Or only protein coding is cool. Not sure. Check with wei. Already this matrix is going to be really really large and the method I used before
does not seem very scalable. 
5. There should be about 3000 single cells from which this data was collected.
6. The way gene Annotation is done is through Gencode. Rizi used Genecode 20 for this analysis. Should she have used something like Genecode 23? I don't know. I don't think this stuff is under my control.
So I should most probably forget about this.
7. I have to find a way to do version control on this data without having to use git. I don't think git can support a repository this size its crazy. Docker might also be hard to use because it does not
work on the cluster. I hate manually copying these files dude. Not cool man. But I think I will have to do it, at least temporarily. Or add these larger files to .gitignore and only do the version control 
on the code itself. I wish there was a way I could make git LFS work. Not cool man. Lets try to figure this out and find a solution.
8. Another point I wanted to add: Rizi told me the following things: the data in the cells is not Log2 of read counts its the log2 of TPM. TPM is calculated as follows: Reads*(10^6)/Total Reads. 
So you will have to probably convert the mouse data to this metric and repeat the analysis. 
9. Another concern is that the mouse Data seems to have used a very unique method that allowed them to calculate exact numbers of mRNA transcripts for each of their single cells.
This is interesting because when reading Lior Patcher's blog about this he said thats its almost impossible to find out exact number of transcripts from RNA-seq data so this is something new. It seems like
Rizi has not followed this logic and the method we have used is different, I think I should look into this, and potentially discuss this with Wei. 
10. Next thing I should do I think is this: I am concerned about the cutoff we used to get the networks and the inverse covariance matrix. Also should I really be using lossy screening. I think I
will not choose this option when I run the analysis again.
11. Next point of concern is this: how do I compare the two mouse and human networks> I should talk to Kai about this dude. The problem is the number of genes in our comparison sample are also not the same.
How do you make the comparison with different numbers of genes in your sample? I have to figure this out.
12. http://www.rna-seqblog.com/rpkm-fpkm-and-tpm-clearly-explained/ Check this out and think carefully about what measure to use for the analysis that you are doing. We already know Rizi used TPM. I don't 
know if she controlled for read length or not. It seems like she did not. In anycase I think I should move my analysis to TPM dude. Damn not corrected for length fuck. I hope I still get reliable results
because the fuck up should be visible in all values of the cell I have right so this should be OK, I hope. 

Update: 
Read the 2014 Nature methods paper about the UMI technique by the Linarsson lab. Its in my ucsd GDrive. The interesting thing is that taking the RPM for their data is ok because its a constant scalling factor.
But as I expected before the counts we get are not proportional to gene lenght so there is no need to correct for that dude. 

Another point. It seems like taking the logarithm of the matrix and then finding the correlations has a small but noticiable effect on the correlations. I have decided to convert the mouse data to this logarithm 
approach dude and then get my network. I think its best to make operations on this network in Java. 
