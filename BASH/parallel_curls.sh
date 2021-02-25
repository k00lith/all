echo Start
date
for i in {10..20} {40..60}
do
time curl -u <имя пользователя>:<пароль> --header "Content-Type: application/json" --request POST --data '{}' "http://192.168.0.${i}:8080/target" &
done
wait
date
echo Finished
