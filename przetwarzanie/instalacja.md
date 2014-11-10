Aby wygodnie pracować z R potrzebujemy trzech elementów (pierwszy jest niezbędny, pozostałe dwa powodują, że praca jest wygodniejsza):

- zainstalować program R, 

- zainstalować program RStudio, nakładkę na R, dzięki której praca z R będzie znacznie bardziej wygodna,

- zainstalować dodatkowe pakiety dla R, które zawierają dodatkowe funkcje, zbiory danych i możliwości.


Instalacja R
------------

Najnowszą wersję R (na dzień dzisiejszy jest to wersja 3.1.2) można pobrać ze strony
http://cran.r-project.org/.
Nie musimy pamiętać tego adresu, wystarczy wpisać w google ‘R GNU’ a powyższy adres będzie pierwszym linkiem.

R można bez problemu zainstalować i używać na systemach operacyjnych Windows, OSX, klonach Linuxa.
R możemy zainstalować również na przenośnym nośniku USB, dzięki czemu, będziemy mogli uruchamiać to środowisko na różnych komputerach.

Nie potrzebujemy specjalnych uprawnień administracyjnych aby zainstalować R, można zainstalować program w swoim lokalnym katalogu. 

R jest całkowicie bezpłatny do wszelkich zastosowań, jest dostępny na licencji GPL 2.


Praca z programem R jest interaktywna, co oznacza, że wpisując polecenia do konsoli R otrzymujemy natychmiast wyniki wykonanych poleceń.


Instalacja RStudio Desktop
--------------------------

Najnowszą wersję RStudio Desktop (na dzień dzisiejszy jest to wersja 0.98) można pobrać ze strony
http://www.rstudio.com/products/rstudio/download/.

Nie musimy pamiętać tego adresu, wystarczy wpisać w google ‘R Studio download’ a powyższy adres będzie pierwszym linkiem.

RStudio jest komercyjnym produktem rozwijanym przez firmę RStudio. Ten program jest dostępny bezpłatnie do większości zastosowań na licencji AGPL 3. Odpłatnie, można również korzystać z tego programu na licencjach komercyjnych.

* Przy domyślnych ustawieniach, w programie RStudio wyświetlane są cztery panele. Lewy górny róg to miejsce w którym pisze się instrukcje. Ten instrukcje można zaznaczyć i wysłać do wykonania poleceniem CTRL+Enter. 
* Lewy donlny panel to konsola programu R, tutaj wyświetlane są instrukcje wprowadzone do R oraz ich wyniki.
* Prawy dolny panel przedstawia wykresy wyprodukowane przez instrukcje w R. W tym panelu jest też wyświetlana pomoc dla funkcji.
* Prawy górny panel pokazuje jakie obiekty znajdują się obecnie w pamięci R, oraz jak są one duże. Klikając na wybrane obiekty możemy podejrzeć ich zawartość.


!(RStudio.png)


Instalacja dodatkowych pakietów
-------------------------------

Program R po instalacji posiada setki przydatnych funkcji.
Ale olbrzymia siła kryje się w dodatkowych pakietach, które można w każdej chwili dodać. 
Dodatkowych pakietów, oficjalnie dostępnych w repozytorium pakietów CRAN jest na dziś dzień ponad 6000. 
Są to pakiety specjalistyczne, dla bioinformatyków, botaników, historyków, lingwistów, osób zainteresowanych obliczeniami rozproszonymi i dla wielu innych specjalistycznych zastosowań.

My, na potrzeby tego kursu, będziemy korzystać z pakietu SmarterPoland, w którym umieszczone są dodatkowe zbiory danych na których będziemy pracować. Instalacja tego pakietu automatycznie wywoła również instalacje wszystkich pakietów zależnych, dzięki czemu jedną linijką możemy zainstalować wszystko, co nam będzie potrzebne w tym kursie.

Instalacje nowego pakietu wykonuje się funkcją install.packages("nazwa pakietu"), którą należy uruchomić w linii poleceń programu R.
Tak więc po instalacji R i RStudio, pierwszym poleceniem, które wpiszemy do konsoli będzie.

    install.packages("SmarterPoland")

Zainstaluje ono z Internetu wszelkie niezbędne pakiety i zbiory danych.

Gotowi do pracy
---------------

Zainstalowaliśmy program R, RStudio i pakiet SmarterPoland?
Jeżeli tak to jesteśmy gotowi do rozpoczęcia pracy z R.


