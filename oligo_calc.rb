require 'pry-byebug'
CODON_TO_AA = {att: 'I1', atc: 'I2', ata: 'I3', 
               ctt: 'L1', ctc: 'L2', cta: 'L3', ctg: 'L4', tta: 'L5', ttg: 'L6',
               gtt: 'V1', gtc: 'V2', gta: 'V3', gtg: 'V4',
               ttt: 'F1', ttc: 'F2',
               atg: 'M1',
               tgt: 'C1', tgc: 'C2',
               gct: 'A1', gcc: 'A2', gca: 'A3', gcg: 'A4',
               ggt: 'G1', ggc: 'G2', gga: 'G3', ggg: 'G4',
               cct: 'P1', ccc: 'P2', cca: 'P3', ccg: 'P4',
               act: 'T1', acc: 'T2', aca: 'T3', acg: 'T4',
               tct: 'S1', tcc: 'S2', tca: 'S3', tcg: 'S4', agt: 'S5', agc: 'S6',
               tat: 'Y1', tac: 'Y2',
               tgg: 'W1',
               caa: 'Q1', cag: 'Q2',
               aat: 'N1', aac: 'N2', 
               cat: 'H1', cac: 'H2',
               gaa: 'E1', gag: 'E2',
               gat: 'D1', gac: 'D2',
               aaa: 'K1', aag: 'K2',
               cgt: 'R1', cgc: 'R2', cga: 'R3', cgg: 'R4', aga: 'R5', agg: 'R6',
               taa: '!1', tag: '!2', tga: '!3'}
AA_TO_CODON = {"I1"=>:att, "I2"=>:atc, "I3"=>:ata, 
               "L1"=>:ctt, "L2"=>:ctc, "L3"=>:cta, "L4"=>:ctg, "L5"=>:tta, "L6"=>:ttg, 
               "V1"=>:gtt, "V2"=>:gtc, "V3"=>:gta, "V4"=>:gtg, 
               "F1"=>:ttt, "F2"=>:ttc, 
               "M1"=>:atg, 
               "C1"=>:tgt, "C2"=>:tgc, 
               "A1"=>:gct, "A2"=>:gcc, "A3"=>:gca, "A4"=>:gcg, 
               "G1"=>:ggt, "G2"=>:ggc, "G3"=>:gga, "G4"=>:ggg, 
               "P1"=>:cct, "P2"=>:ccc, "P3"=>:cca, "P4"=>:ccg, 
               "T1"=>:act, "T2"=>:acc, "T3"=>:aca, "T4"=>:acg, 
               "S1"=>:tct, "S2"=>:tcc, "S3"=>:tca, "S4"=>:tcg, "S5"=>:agt, "S6"=>:agc, 
               "Y1"=>:tat, "Y2"=>:tac, 
               "W1"=>:tgg, 
               "Q1"=>:caa, "Q2"=>:cag, 
               "N1"=>:aat, "N2"=>:aac, 
               "H1"=>:cat, "H2"=>:cac, 
               "E1"=>:gaa, "E2"=>:gag, 
               "D1"=>:gat, "D2"=>:gac, 
               "K1"=>:aaa, "K2"=>:aag, 
               "R1"=>:cgt, "R2"=>:cgc, 
               "R3"=>:cga, "R4"=>:cgg, 
               "R5"=>:aga, "R6"=>:agg, 
               "!1"=>:taa, "!2"=>:tag, "!3"=>:tga}
VARIANTS = {"I"=>["1", "2", "3"], "L"=>["1", "2", "3", "4", "5", "6"],
            "V"=>["1", "2", "3", "4"], "F"=>["1", "2"], "M"=>["1"],
            "C"=>["1", "2"], "A"=>["1", "2", "3", "4"], "G"=>["1", "2", "3", "4"], 
            "P"=>["1", "2", "3", "4"], "T"=>["1", "2", "3", "4"], 
            "S"=>["1", "2", "3", "4", "5", "6"], "Y"=>["1", "2"], "W"=>["1"], 
            "Q"=>["1", "2"], "N"=>["1", "2"], "H"=>["1", "2"], "E"=>["1", "2"], 
            "D"=>["1", "2"], "K"=>["1", "2"], "R"=>["1", "2", "3", "4", "5", "6"], 
            "!"=>["1", "2", "3"]}

def open_file(file_name='input')
  input = ''
  File.open(file_name, 'r') do |f|
    f.each_line do |line|
      input << line
    end
  end
  input
end

def dna_to_aa(dna)
  codons = dna.chars.each_slice(3).map(&:join)
  codons.map do |codon|
    CODON_TO_AA.fetch(codon.downcase.to_sym)
  end.join('')
end

def aa_to_dna(aa_seq)
  aas = aa_seq.chars.each_slice(2).map(&:join)
  aas.map do |aa|
    AA_TO_CODON.fetch(aa).upcase
  end.join('')
end

def find_percentage(aa, aa_seq)
  matches = find_num_matches(aa, aa_seq)
  ((matches.to_f/(aa_seq.length / 2))*100).round(2)
end

def find_num_matches(aa, aa_seq)
  matches = aa_seq.chars.each_slice(2).map(&:join).select{|aa_sym| aa_sym.chars.first == aa.chars.first}.size
end

input = open_file.gsub('\n','').split(':')
dna_seq = input[0]
target = CODON_TO_AA.fetch(input[1].to_sym)
design = input[2]
frag_len = input[3].to_i
num_frags = input[4].to_i
delta = input[5].to_f
aa_seq = dna_to_aa(dna_seq)
aa_seq_w_sections = aa_seq.chars.each_slice(frag_len*2).map(&:join)
puts "------------------------------"
puts "DNA: #{dna_seq}"
puts "Target AA: #{target}"
puts "Design: #{design}"
puts "Fragment Length: #{frag_len}"
puts "# of Fragments: #{num_frags}"
puts "Delta: #{delta}%"
puts "------------------------------"
puts "Amino Acid's in Sections:"
puts aa_seq_w_sections
puts "------------------------------"
puts "Amino Acids converted back to DNA:"
puts aa_to_dna(aa_seq)
puts "------------------------------"
puts "% of target in seq:"
puts find_percentage(target, aa_seq).to_s << "%"
puts "------------------------------"
byebug
""