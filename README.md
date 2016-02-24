
Читаем:</br>
https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSURLSession_class/</br>
http://www.raywenderlich.com/51127/nsurlsession-tutorial</br>
http://code.tutsplus.com/tutorials/networking-with-nsurlsession-part-1--mobile-21394</br>
http://code.tutsplus.com/tutorials/networking-with-nsurlsession-part-2--mobile-21581</br>
http://nshipster.com/cocoapods/</br>
https://developer.apple.com/library/watchos/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html</br>
</br>
Домашнее задание (На основе демо которое мы делали в классе)</br>
1. Загружаем список треков по URL https://itunes.apple.com/search?term=rock&country=US&entity=song</br>
2. Результат выводим в таблицу, в каждой строке имя исполнителя, название композиции и кнопка Download/Play</br>
3. По нажатию на кнопку Download загружать композицию на диск</br>
4. По нажатию на кнпоку Play запускать проигрывание композиции</br>
5. Показывать UIActivityIndicatorView и UILabel с прогрессом загрузки композиции</br>
<b>Рекомендация:</b> Создайте класс для инкапсуляции логики загрузки (с полями url, fileUrl, progress, isDownloading, isDownloaed, downloadTask и объект полученный из JSON) и используйте его для конфигурации ячеек. При инициализации этого класса проверяйте наличие загруженной композиции. UI приложения после перезагрузки не должен предлагать загрузить загруженные ранее файлы </br>
6. С помощью Cocoapods (cocoapods.org) добавьте в ваш проект любую фото галерею которая умеет отображать картинки по URL. Галереи можно поискать на cocoacontrols.com или github.com в разделе Explore</br>
7. По нажатию на ячейку производите загрузку картинок исполнителя по URL https://api.imgur.com/3/gallery/search/top/0?q=СЮДА_ИМЯ_ИСПОЛНИТЕЛЯ.</br> Для успешной загрузки нужно добавить заголовок запроса (Header) Authorization: Client-ID 510d3df1e146294</br>
8. После загрузки картинок отдайте полученный массив URL добавленной галерее и покажите ее.</br>
