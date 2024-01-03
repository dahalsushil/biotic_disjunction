          seed = -1
      seqfile = ./concatenated.50missing.50taxadeleted.virgulus.fixed.fasta
      treefile = ./astral.sushilmegatree.subg.virgulus.redo.newick.noduplicate.formatted.tre
     outfile = out

         *ndata = 143
       seqtype = 0  * 0: nucleotides; 1:codons; 2:AAs
       usedata = 2    * 0: no data; 1:seq like; 2:use in.BV; 3: out.BV
         clock = 3    * 1: global clock; 2: independent rates; 3: correlated rates
       RootAge = <0.32  * safe constraint on root age, used if no fossil for root. This is approx stem age of Astereae from Mandel et al. 2019

         model = 7    * 0:JC69, 1:K80, 2:F81, 3:F84, 4:HKY85
         alpha = 0.5    * alpha for gamma rates at sites
         ncatG = 5    * No. categories in discrete gamma

     cleandata = 0    * remove sites with ambiguity data (1:yes, 0:no)?

       BDparas = 1 1 0    * birth, death, sampling
   kappa_gamma = 6 2      * gamma prior for kappa
   alpha_gamma = 1 1      * gamma prior for alpha

   rgene_gamma = 1 6.17    * gamma prior for overall rates for genes
  sigma2_gamma = 1 4.5    * gamma prior for sigma^2     (for clock=2 or 3)

      finetune = 1: 0.1  0.1  0.1  0.01 .5  * auto (0 or 1) : times, musigma2, rates, mixing, paras, FossilErr

         print = 1
        burnin = 50,000,000
      sampfreq = 1,000
       nsample = 50000

*** Note: Make your window wider (100 columns) before running the program.
