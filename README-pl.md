# Sudoku
Ten program jest desktopową implementacją popularnej gry Sudoku. Projekt i funkcjonalność gry oparte są na aplikacji Sudoku.com studia EasyBrain Studio dostępnej w sklepie Google Play. Ponadto ta aplikacja współpracuje z Sudoku-Generator API w celu uzyskania losowej tablicy wraz z jej rozwiązaniem.

## Instalacja i użytkowanie
Aby uruchomić program, musisz mieć zainstalowany Matlab na swoim komputerze oraz aktywną subskrybcję Sudoku-Generator API dostępnego pod adresem: https://rapidapi.com/gregor-i/api/sudoku-generator1. Korzystanie z tego API jest bezpłatne do maksymalnie 1000 obiektów dziennie. W pliku .env należy wypełnić następujące atrybuty: content-type, X-RapidAPI-Key i X-RapidAPI-Host. Wartości dwóch ostatnich atrybutów można skopiować z fragmentu kodu z prawej kolumny na stronie RapidAPI wskazanej w tej sekcji. Typ zawartości powinien być ustawiony na 'application/octet-stream'. Program jest uruchamiany poprzez uruchomienie pliku Sudoku.m w Matlabie przy użyciu standardowego sposobu uruchamiania takich skryptów, albo poprzez kliknięcie przycisku 'Uruchom' w górnym panelu, albo za pomocą skrótu klawiaturowego Ctrl+Enter.

## Jak grać
Okno gry składa się z planszy i panelu sterowania na dole. Użytkownik wypełnia pola planszy wybierając najpierw przycisk z cyfrą, którą chce wprowadzić w wolnym polu planszy lub literą 'X' służącą jako gumka. Następnie klika na zaznaczone pole i wtedy jeśli numer można umieścić w tym polu, pojawia się on w jego wnętrzu jako tekst. Po wypełnieniu wszystkich pól wyświetlone zostanie okno informujące użytkownika o wygranej i pozwalające użytkownikowi wybrać pomiędzy ponownym uruchomieniem gry a jej zakończeniem. Każdy użytkownik ma limit 3 błędów na grę. Jeśli przekroczy ten limit, przegra grę. Licznik niepowodzeń znajduje się po prawej stronie planszy.

## Funkcje
Gra posiada następujące funkcjonalności:
- Na początku gry gracz wybiera poziom trudności klikając na odpowiedni przycisk. Wybór gracza jest wysyłany wraz z żądaniem Get do API, z którego zostanie odebrana wygenerowana losowo plansza o wybranym poziomie trudności.
- Pola, które są wstępnie wypełnione na początku gry są nieaktywne, a gracz nie może modyfikować ich wartości.
- Użytkownik może mieć aktywny tylko jeden przycisk z cyfrą lub literą "X" na raz. Jeśli naciśniesz inny przycisk, przycisk który był wciśnięty wcześniej staje się nieaktywny. Wyjątkiem jest przycisk "N", który może być aktywny razem z innym przyciskiem.
- Tryb Notatek - służy do rejestrowania potencjalnych wartości, które mogą być umieszczone w pustych polach. Aby go aktywować, użytkownik musi nacisnąć przycisk 'N'. Wyświetlane liczby są przedstawione w porządku rosnącym i mogą być zarówno dodawane, jak i usuwane z puli. Jeśli liczby nie mieszczą się w obrębie danego pola, reszta puli jest wyświetlana, gdy użytkownik najedzie kursorem na takie pole.
- Gumka - po naciśnięciu przycisku 'X' użytkownik może usunąć zawartość uprzednio wypełnionego pola klikając na nie.
- Pola, które użytkownik wypełnił ostateczną wartością (nie w trybie notatek) zmieniają kolor na zielony.
- Po wypełnieniu wszystkich pól, użytkownik otrzymuje powiadomienie o wygranej i może wybrać grę ponownie lub zakończyć grę.
- Gra zlicza liczbę pozostałych ruchów za pomocą zmiennej 'moves'. Główna i najważniejsza struktura całego programu jest przechowywana w zmiennej 'handles'. Przechowuje ona odniesienia do najbardziej krytycznych elementów sterujących rozgrywką i statystyk, takich jak liczba pozostałych ruchów, odniesienia do elementów planszy lub liczba aktualnie wybrana przez użytkownika.
- Ważną rolę odgrywa również funkcja "guidata". W pierwszym wywołaniu tej funkcji w ramach funkcji "createSudokuBoard()" program przypisuje strukturę "handles" do okna zawierającego elementy tej struktury. W ciałach funkcji obsługujących kliknięcia aplikacja najpierw przekazuje przycisk, który wywołał zdarzenie, do funkcji "guidata", która zwraca bieżący stan struktury "handles". Na końcu tych funkcji stan struktury "handles" jest aktualizowany, po czym następuje kolejne wywołanie funkcji "guidata", w której ponownie przekazywane jest źródło zdarzenia i bieżący stan "handles", co skutkuje aktualizacją stanu okna gry.

## Planowane nowości
- dodanie licznika czasu

## Interfejs gry
![image](https://github.com/Marcin-Ramotowski/Sudoku/assets/109000485/1e52a762-2f3f-46e2-bda2-79a97525c443)