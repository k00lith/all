echo -n "Enter environment (For Development 'D', QA 'Q' Production 'P' and press [ENTER]: "
read name
s1=${name/|/\\\|}\\\|.*=RL*
s2=${name/|/\\\|}\\\|OD\\\|RLE\\\|R.*RL*
echo *********Getting Strings used In Given Environment***************
hbase shell <<< "scan 'platform:config',{COLUMNS=>'data:StringIDs'}" | grep -E "$s1" >StringsUsed.txt
echo ********Getting Strings exists in Given Environment*************
hbase shell <<< "scan 'platform:config',{COLUMNS=>'data:id'}" | grep -E "$s2" > StringsExists.txt
sed -i -e 's/.*value=//g' -e 's/|/\n/g' -e '/^$/d' StringsUsed.txt
sed -i -e 's/.*value=//g' -e 's/|/\n/g' -e '/^$/d' StringsExists.txt
rm -f StringsExistsSorted.txt
rm -f StringsUsedSorted.txt
sort -u StringsExists.txt >> StringsExistsSorted.txt
sort -u StringsUsed.txt >> StringsUsedSorted.txt
echo **************Output***********
echo 'If any String inconsitent it will return list of Strings ids otherwise it will return empty.'
comm -23  StringsUsedSorted.txt StringsExistsSorted.txt
