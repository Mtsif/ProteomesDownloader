
anno() {
#wget -O proteomes.txt https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/reference_proteomes/STATS
#sed -i '1,15d' proteomes.txt

wget -O proteomes.txt https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/reference_proteomes/README
sed -i '1,154d;23961,23982d' proteomes.txt
}

download() {
mkdir -p files
data=$(grep -w -f  \
<(cut -f1 taxonomy_host_9606_AND_taxonomies_with_2023_08_24.tsv) \
<(cut -f1-2,4 proteomes.txt) )

while read -r org; do
folder=$(echo "$org" | cut -f3 )
name=$(echo "$org" | awk '{print $1}')
filename=$(echo "$org" | awk '{print $1 "_" $2 }')

#echo "${folder^} ${name}"
path=$(echo "https://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/reference_proteomes/${folder^}/${name}/")
wget -P files/ -r -l1 -e robots=off --no-parent -A "fasta.gz" -nd $path

done < <(echo "$data")
}

notes() {
echo "
Protein FASTA files (*.fasta and *_additional.fasta)
====================================================

These files, composed of canonical and additional sequences, are non-redundant
FASTA sets for the sequences of each reference proteome.
The additional set contains isoform/variant sequences for a given gene, and its
FASTA header indicates the corresponding canonical sequence (\"Isoform of ...\").
The FASTA format is the standard UniProtKB format.

For further references about the standard UniProtKB format, please see:
    http://www.uniprot.org/help/fasta-headers
    http://www.uniprot.org/faq/38

E.g. Canonical set:
>sp|Q9H6Y5|MAGIX_HUMAN PDZ domain-containing protein MAGIX OS=Homo sapiens GN=MAGIX PE=1 SV=3
MEPRTGGAANPKGSRGSRGPSPLAGPSARQLLARLDARPLAARAAVDVAALVRRAGATLR
LRRKEAVSVLDSADIEVTDSRLPHATIVDHRPQHRWLETCNAPPQLIQGKAHSAPKPSQA
SGHFSVELVRGYAGFGLTLGGGRDVAGDTPLAVRGLLKDGPAQRCGRLEVGDVVLHINGE
STQGLTHAQAVERIRAGGPQLHLVIRRPLETHPGKPRGVGEPRKGVVPSWPDRSPDPGGP
EVTGSRSSSTSLVQHPPSRTTLKKTRGSPEPSPEAAADGPTVSPPERRAEDPNDQIPGSP
GPWLVPSEERLSRALGVRGAAQFAQEMAAGRRRH

E.g. Additional sets:
>sp|Q9H6Y5-2|MAGIX_HUMAN Isoform of Q9H6Y5, Isoform 2 of PDZ domain-containing protein MAGIX OS=Homo sapiens GN=MAGIX PE=1 SV=4
MPLLWITGPRYHLILLSEASCLRANYVHLCPLFQHRWLETCNAPPQLIQGKAHSAPKPSQ
ASGHFSVELVRGYAGFGLTLGGGRDVAGDTPLAVRGLLKDGPAQRCGRLEVGDVVLHING
ESTQGLTHAQAVERIRAGGPQLHLVIRRPLETHPGKPRGVGEPRKGVVPSWPDRSPDPGG
PEVTGSRSSSTSLVQHPPSRTTLKKTRGSPEPSPEAAADGPTVSPPERRAEDPNDQIPGS
PGPWLVPSEERLSRALGVRGAAQFAQEMAAGRRRH
>tr|C9J123|C9J123_HUMAN Isoform of Q9H6Y5, PDZ domain-containing protein MAGIX (Fragment) OS=Homo sapiens GN=MAGIX PE=1 SV=2
MSPNSPLHCFYLPAVSVLDSADIEVTDSRLPHATIVDHRPQVGDLVLHINGESTQGLTHA
QAVERIRAGGPQLHLVIRRPLETHPGKPRGVGEPRKGVDRSPDPGGPEVTGSRSSSTSLV
QHPPSRTTLKKTRGSPEPSPEAA


Coding DNA Sequence FASTA files (*_DNA.fasta)
=============================================

These files contain the coding DNA sequences (CDS) for the protein sequences
where it was possible, considering only canonical accessions.
The format is as in the following example (UP000005640_9606_DNA.fasta):

>sp|A0A183|ENSP00000411070
ATGTCACAGCAGAAGCAGCAATCTTGGAAGCCTCCAAATGTTCCCAAATGCTCCCCTCCC
CAAAGATCAAACCCCTGCCTAGCTCCCTACTCGACTCCTTGTGGTGCTCCCCATTCAGAA
GGTTGTCATTCCAGTTCCCAAAGGCCTGAGGTTCAGAAGCCTAGGAGGGCTCGTCAAAAG
CTGCGCTGCCTAAGTAGGGGCACAACCTACCACTGCAAAGAGGAAGAGTGTGAAGGCGAC
TGA

The 3 fields of the FASTA header are:
1) 'sp' (Swiss-Prot reviewed) or 'tr' (TrEMBL)
2) UniProtKB Accession
3) EMBL Protein ID or Ensembl/Ensembl Genome ID
" > notes.txt
}

anno
download
notes

