library(cummeRbund)
library(feather)

setwd("C:\\Users\\mrj55\\Documents\\Harvard\\Mitchell\\AA_RNAseq\\diff")

cuff <- readCufflinks()

gene.features <- annotation(genes(cuff))
head(gene.features)

###Create fpkm table by group
gene.fpkm <- fpkm(genes(cuff))
gene.fpkm <- merge(x = gene.fpkm, y = gene.features[,c("gene_id", "gene_short_name")], by = "gene_id", all.x = T)
head(gene.fpkm)

###Create fpkm table by replicate (long format)
gene.reFpkm <- repFpkm(genes(cuff))
gene.reFpkm <- merge(x = gene.reFpkm, y = gene.features[,c("gene_id", "gene_short_name")], by = "gene_id", all.x = T)
head(gene.reFpkm, 16)

###Create differential expression table and remove un-annotated genes
gene.diff <- diffData(genes(cuff))
head(gene.diff, 24)
gene.diff <- merge(x = gene.diff, y = gene.features[,c("gene_id", "gene_short_name")], by = "gene_id", all.x = T)
gene.diff <- gene.diff[!is.na(gene.diff$gene_short_name),]
gene.diff$compared <- factor(interaction(gene.diff$sample_1, gene.diff$sample_2),
                             labels = c("WT0h_KO0h", "WT0h_KO3h", "KO0h_KO6h", "WT0h_WT3h",
                                        "WT3h_KO6h", "WT3h_KO_3h", "WT3h_WT6h", "WT6h_KO6h",
                                        "KO3h_WT6h", "KO0h_WT3h", "WT0h_WT6h", "KO0h_KO3h",
                                        "KO3h_KO6h", "WT0h_KO6h", "KO0h_WT6h"
                             ))

###Create fpkm table by replicate (short format)
gene.rep.mat <- repFpkmMatrix(genes(cuff))
gene.rep.mat$gene_id <- rownames(gene.rep.mat)
head(gene.rep.mat)
gene.rep.mat <- merge(x = gene.rep.mat, y = gene.features[,c("gene_id", "gene_short_name")], by = "gene_id", all.x = T)
gene.rep.mat2 <- data.frame(t(gene.rep.mat[,2:26]))
colnames(gene.rep.mat2) <- gene.rep.mat$gene_short_name
gene.rep.mat2 <- gene.rep.mat2[-25,]

gene.rep.mat2$Time <- factor(c(rep(0, 8), rep(3, 8), rep(6, 8)))
gene.rep.mat2$Treatment <- factor(c(rep("WT", 4), rep("KO", 4),
                                    rep("WT", 4), rep("KO", 4),
                                    rep("WT", 4), rep("KO", 4)))


setwd("C:\\Users\\mrj55\\Documents\\Harvard\\Mitchell\\shinyApps\\AAseq\\Data")

write.csv(gene.diff, "gene_diff.csv")
write_feather(gene.diff, "gene_diff.feather")

write.csv(gene.rep.mat2, "gene_rep_mat.csv")
write_feather(gene.rep.mat2, "gene_rep_mat.feather")

write.csv(gene.reFpkm, "gene_reFpkm.csv")
write_feather(gene.reFpkm, "gene_reFpkm.feather")


