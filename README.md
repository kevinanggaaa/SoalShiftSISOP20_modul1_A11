# SoalShiftSISOP20_modul1_A11

1. Whits adalah seorang mahasiswa teknik informatika. Dia mendapatkan tugas praktikum untuk membuat laporan berdasarkan data yang ada pada file "*Sample-Superstore.tsv*". Namun dia tidak dapat menyelesaikan tugas tersebut. Laporan yang diminta berupa :

      a.  Tentukan wilayah bagian (region) mana yang memiliki keuntungan (profit) paling sedikit.

      b. Tampilkan 2 negara bagian (state) yang memiliki keuntungan (profit) paling sedikit berdasarkan hasil poin a

      c. Tampilkan 10 produk (product name) yang memiliki keuntungan (profit) paling sedikit berdasarkan 2 negara bagian (state) hasil poin b
Whits memohon kepada kalian yang sudah jago mengolah data untuk mengerjakan laporan tersebut.

- Gunakan Awk dan Command pendukung.


**Soal1.sh**
  
  
      #!/bin/bash
      awk -F "\t" 'NR > 1 {
      region = $13;
      state = $11;
      prod_name = $17
      profit = $21;

      regions[region] += profit;
      states[region, state] += profit;
      products[region, state, prod_name] += profit;
      }

      END {
      # find the region that has the least profit
      # min_region: name region that has the least profit
      for (region in regions) {
        # set first value of min_region as one of the keys in regions
        if (min_region == "" ) {
          min_region = region;
          continue;
        }
 
      # if found curr region is lower value, set min_value to region with lower value
            if ( regions[region] < regions[min_region]) {
                  min_region = region;
            }
      }
      print "region least profitable: " min_region "= " regions[min_region];

      # remove all data thats from other regions
      # remove data from states array

      for (key in states) {
        split(key, res, SUBSEP);
        region = res[1]; state = res[2];
        
        if (region != min_region) {
          delete states[key];
        }
      }

      # remove data from products array
      for (key in products) {
        split(key, res, SUBSEP);
        region = res[1]; state = res[2]; product = res[3];
        
        if (region != min_region) {
          delete products[key];
        }
      }

      # end of removing data based on region
      # smallest_state state with smallest
      # small_state state second smallest
      # find 2 smallest state profit value
      for(key in states) {
        split(key, res, SUBSEP);
        region = res[1]; state = res[2];

        # set inital value of smallest_state variabel as one of the states
        if ( smallest_state == "") {
          smallest_state = state;
          continue;
        }

        # initialize value of small_state as one of the states
        if ( small_state == "" ) {
        
          # check if its current is smaller than current smallest
          if ( states[key] < states[region, smallest_state] ) {
            small_state = smallest_state;
            smallest_state = state;
          } 
          
          else {
            small_state = state;
          }
          continue;
        }
        
        # if found new smallest value, update smallest
            if ( states[key] < states[region, smallest_state]) {
                  small_state = smallest_state; 
                  smallest_state = state;
            }
           
           # If value is in between smallest and small then update small
            else if ( states[key] < states[region, small_state] && states[key] != states[region, smallest_state] ) {
                  small_state = state;
            }
      }

      # print least profitable state and second least profitable state
      print "least profitable state: " smallest_state "= " states[min_region, smallest_state];
      print "second least profitable state: " small_state "= " states[min_region, small_state];

      # remove all data in products aray thats from other states
      for (key in products) {
        split(key, res, SUBSEP);
        region = res[1]; state = res[2]; product = res[3];
        
        if (state != smallest_state && state != small_state) {
          delete products[key];
        }
      }

      # sum all products from the smallest_state and small_state
      for (key in products) {
        split(key, res, SUBSEP);
        region = res[1]; state = res[2]; product = res[3];
        sum_products[product] += products[key];
      }

      # sort products from least profit to most profit
      PROCINFO["sorted_in"]="@val_num_asc"
      print "10 least profitable products";
      i = 1;
      
      for(product in sum_products) {
        if (i <= 10) {
          print i ". " product "= " sum_products[product]
          i++
        } 
        
        else {
          break;
        }
      }
      }' ~/Downloads/Sample-Superstore.tsv


2. Pada suatu siang, laptop Randolf dan Afairuzr dibajak oleh seseorang dan kehilangan data-data penting. Untuk mencegah kejadian yang sama terulang kembali mereka meminta bantuan kepada Whits karena dia adalah seorang yang punya banyak ide. Whits memikirkan sebuah ide namun dia meminta bantuan kalian kembali agar ide tersebut cepat diselesaikan. Idenya adalah kalian (a) membuat sebuah script bash yang dapat menghasilkan password secara acak sebanyak 28 karakter yang terdapat huruf besar, huruf kecil, dan angka. (b) Password acak tersebut disimpan pada file berekstensi .txt dengan nama berdasarkan argumen yang diinputkan dan HANYA berupa alphabet. (c) Kemudian supaya file .txt tersebut tidak mudah diketahui maka nama filenya akan di enkripsi dengan menggunakan konversi huruf (string manipulation) yang disesuaikan dengan jam(0-23) dibuatnya file tersebut dengan program terpisah dengan (misal: password.txt dibuat pada jam 01.28 maka namanya berubah menjadi qbttxpse.txt dengan perintah ‘bash soal2_enkripsi.sh password.txt’. Karena p adalah huruf ke 16 dan file dibuat pada jam 1 maka 16+1=17 dan huruf ke 17 adalah q dan begitu pula seterusnya. Apabila melebihi z, akan kembali ke a, contoh: huruf w dengan jam 5.28, maka akan menjadi huruf b.) dan (d) jangan lupa untuk membuat dekripsinya supaya nama file bisa kembali.

- HINT: enkripsi yang digunakan adalah caesar cipher.

- Gunakan Bash Script


**soal2.sh**

      #!/bin/bash
      # random string with lower, upper, number
      lower=( {a..z} )
      upper=( {A..Z} )
      num=( {0..9} )
      all=( "${lower[@]}" "${upper[@]}" "${num[@]}" )

      #random 1 number
      idx=$(($RANDOM % 10))
      pass_res+="${num[$idx]}"
      
      #random 1 upper
      idx=$(($RANDOM % 26))
      pass_res+="${lower[$idx]}"
      
      #random 1 lower
      idx=$(($RANDOM % 26))
      pass_res+="${upper[$idx]}"

      for i in {1..30}; do
        idx=$(($RANDOM % 62))
        pass_res+="${all[$idx]}"
      done

      pass_res=`echo "$pass_res" | sed 's/./&\n/g' | shuf | tr -d '\n'`
      echo "$pass_res"


**Soal2_coba.sh**

      #!/bin/bash
      # get filename from input
      old_IFS="$IFS"
      IFS='.'
      read -ra inp <<< "$1"
      
      filename="${inp[0]}"
      fileext="${inp[1]}"
      IFS="$old_IFS"
      offset=$((`date +"%H"`))
      
      lower=( {a..z} )
      
      tr_regex=${lower[$offset]}"-za-"${lower[$(($offset-1))]};
      filename=`echo "$filename" | tr "a-z" $tr_regex`
      filename="${filename}.${fileext}"

      `echo $(bash soal2.sh) > $filename`


**Soal2_wadaw.sh**

      #!/bin/bash
      # get password
      password=`cat $1`

      ## prepare decode ROT cypher
      # get offset
      offset=$((`date -r "$1" "+%H"`))
      
      # get filename from command line argument
      old_IFS="$IFS"
      IFS='.'
      read -ra inp <<< "$1"
      filename="${inp[0]}"
      fileext="${inp[1]}"
      IFS="$old_IFS"

      # set tr regex
      lower=( {a..z} )
      tr_regex=${lower[$offset]}"-za-"${lower[$(($offset-1))]};

      # decode ROT cypher
      filename=`echo "$filename" | tr "$tr_regex" "a-z"`
      filename="${filename}.${fileext}"

      # save pass to original filename to file
      `echo $password > $filename`

3. 1 tahun telah berlalu sejak pencampakan hati Kusuma. Akankah sang pujaan hati kembali ke naungan Kusuma? Memang tiada maaf bagi Elen. Tapi apa daya hati yang sudah hancur, Kusuma masih terguncang akan sikap Elen. Melihat kesedihan Kusuma, kalian mencoba menghibur Kusuma dengan mengirimkan gambar kucing. [a] Maka dari itu, kalian mencoba membuat script untuk mendownload 28 gambar dari "https://loremflickr.com/320/240/cat" menggunakan command wget dan menyimpan file dengan nama "pdkt_kusuma_NO" (contoh: pdkt_kusuma_1, pdkt_kusuma_2, pdkt_kusuma_3) serta jangan lupa untuk menyimpan log messages wget kedalam sebuah file "wget.log". Karena kalian gak suka ribet, kalian membuat penjadwalan untuk menjalankan script download gambar tersebut. Namun, script download tersebut hanya berjalan[b] setiap 8 jam dimulai dari jam 6.05 setiap hari kecuali hari Sabtu Karena gambar yang didownload dari link tersebut bersifat random, maka ada kemungkinan gambar yang terdownload itu identik. Supaya gambar yang identik tidak dikira Kusuma sebagai spam, maka diperlukan sebuah script untuk memindahkan salah satu gambar identik. Setelah memilah gambar yang identik, maka dihasilkan gambar yang berbeda antara satu dengan yang lain. Gambar yang berbeda tersebut, akan kalian kirim ke Kusuma supaya hatinya kembali ceria. Setelah semua gambar telah dikirim, kalian akan selalu menghibur Kusuma, jadi gambar yang telah terkirim tadi akan kalian simpan kedalam folder /kenangan dan kalian bisa mendownload gambar baru lagi. [c] Maka dari itu buatlah sebuah script untuk mengidentifikasi gambar yang identik dari keseluruhan gambar yang terdownload tadi. Bila terindikasi sebagai gambar yang identik, maka sisakan 1 gambar dan pindahkan sisa file identik tersebut ke dalam folder ./duplicate dengan format filename "duplicate_nomor" (contoh : duplicate_200, duplicate_201). Setelah itu lakukan pemindahan semua gambar yang tersisa kedalam folder ./kenangan dengan format filename "kenangan_nomor" (contoh: kenangan_252, kenangan_253). Setelah tidak ada gambar di current directory, maka lakukan backup seluruh log menjadi ekstensi ".log.bak". Hint : Gunakan wget.log untuk membuat location.log yang isinya merupakan hasil dari grep "Location".

- Gunakan Bash, Awk dan Crontab

**soal3.sh**

      #!/bin/bash

      wd=$(pwd);

      if [ ! -d kenangan ]; then
        mkdir kenangan;
      fi

      if [ ! -d duplicate ]; then
        mkdir duplicate;
      fi

      if [ ! -f location.log ]; then
        echo "" > location.log;
      fi



      # find last filename
      last_file_num=$(ls "kenangan" | awk -F "_" 'BEGIN {max = 0} {if ($2 > max) {max = $2} } END {print max}')
      start_num=$(( ${last_file_num}+1 ));

      end_num=$(($start_num+27));
      # end_num=$(( ${start_num}+3 ));

      file_arr=( )
      for (( i = $start_num; i <= $end_num; i++ )); do
        file_arr+=("pdkt_kusuma_${i}")
        wget -O "pdkt_kusuma_${i}" https://loremflickr.com/320/240/cat -a wget.log
      done

      # get all download location from the currently downloaded one
      link_arr=( $(awk '/Location:/ {print}' wget.log) )


      # check duplicates
      for (( i = 0; i <= $end_num-$start_num; i++ )); do
        is_dup=$(awk '/"${link_arr[$i]}"/ {a=1} END {if (a==1) {print 1}}' location.log )
        if [[ $is_dup == "1" ]]; then
          temp=$((${i}+${start_num}))
          `mv pdkt_kusuma_$temp duplicate/duplicate_$temp`
        else
          temp=$((${i}+${start_num}))
          `mv pdkt_kusuma_$temp kenangan/kenangan_$temp`
        fi
      done

      # appned to location.log
      for i in "${link_arr[@]}"; do
        is_dup=$(awk '/"${link_arr[$i]}"/ {a=1} END {if (a==1) {print 1}}' location.log )

        if [[ $is_dup != "1" ]]; then
          `printf '%s\n' "$i" >> location.log`
        fi
      done

      # backup logs
      $(mv wget.log "wget $(date).bak.log")


**Crontab**
     
     5 6,14,22 * * 0-5 cd ~/Documents/shift1/soal3 && ./soal3.sh
