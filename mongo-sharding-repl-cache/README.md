## Кеширование данных 

### Описание проекта    
В целях повышения **производительности при высокой нагрузке на операции чтения редко изменяемых одинаковых данных** применяется кеширование этих данных.  
В проекте в качестве кеша применяется Redis, который хранит данные в оперативной памяти и распологается перед базой MongoDB, что позволяет получить данные быстрее. 
На кеш дополнительно устанавливается время его жизни (time to leave), что позволяет периодически его обновлять. 
Выполненные нагрузочные тесты с метриками производительности показывают эффективность применения кеширования.     

Как запустить?  
Выполнить docker compose up -d в терминале из папки mongo-sharding-repl с файлом compose.yml    
[<img src="./readme/docker-console-run.png" width="450"/>](./readme/docker-console-run.png)    

Инициализируем сервер конфигурации, шарды, реплики, роутер, задаем метод шардирования и наполняем данными    
```shell
./scripts/mongo-init.sh
```
Приложение доступно на 8080 порту.  

Спецификация openAPI доступна на 8080/docs  
![img.png](readme/openapi.png)  

Конфигурация mongodb доступна на 8080/    
![img.png](readme/mongo-configs.png)

Очистка кешей по истечении time-to-leave 60сек  
<img src="./readme/redis-ttl.png" width="1500"/> 

### Нагрузочные тесты      
Без кеширования     
<img src="./readme/performance_without_cache.png" width="800"/>   
    
С кешированием      
<img src="./readme/performance_with_cache.png" width="800"/>    
    
### Архитектура приложения
[<img src="./readme/architecture.png" width="800"/>](./readme/architecture.png)   

### Использованные технологии   
-Python     
-FastAPI Framework   
-MongoDB, Compass   
-Redis  
-Postman    
-Docker     
-Intellij Idea  