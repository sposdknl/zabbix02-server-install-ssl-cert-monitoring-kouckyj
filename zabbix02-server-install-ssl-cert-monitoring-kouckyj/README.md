Automatizovaná instalace Zabbix serveru a agenta

Tento projekt obsahuje skript, který plně automatizuje instalaci a konfiguraci Zabbix serveru 7.0 LTS, databáze MySQL a Zabbix agenta 2 na Ubuntu 24.04. Skript je navržen tak, aby po jeho spuštění byl Zabbix okamžitě připraven k použití a dostupný přes webové rozhraní.

Nejprve se stáhne a nainstaluje oficiální repozitář Zabbix pro Ubuntu, aby bylo možné získat aktuální balíčky. Poté se nainstalují všechny potřebné komponenty: samotný Zabbix server, webový frontend s podporou PHP a Apache, SQL skripty a Zabbix agent2. Součástí je také instalace MySQL serveru a ukázkových pluginů pro agenta, které demonstrují rozšířené možnosti monitoringu.

Skript následně inicializuje databázi. Vytvoří databázi s názvem „zabbix“, nastaví správnou znakovou sadu a kolaci, vytvoří uživatele s potřebnými oprávněními a dočasně povolí funkce nutné pro import schématu. Do databáze se následně importuje základní struktura tabulek, která je nezbytná pro běh Zabbix serveru. Po dokončení se bezpečnostní nastavení vrátí zpět do původního stavu.

Dalším krokem je konfigurace samotného Zabbix serveru. Do konfiguračního souboru se vloží heslo pro přístup k databázi, aby server mohl správně komunikovat s MySQL. Následuje vytvoření konfiguračního souboru pro webový frontend, kde se nastavují parametry připojení k databázi a také podpis serveru, který se zobrazí v uživatelském rozhraní. V tomto případě je server podepsán jako „Kouckyj Server“.

Součástí skriptu je i ukázková konfigurace MySQL, která se uloží do souboru mysql.ini. Nejde o kritické nastavení, ale o demonstraci práce s konfiguračními soubory. Obsahuje například volbu pro vypnutí překladu jmen a nastavení výchozí znakové sady.

Na závěr skript restartuje všechny důležité služby — Zabbix server, Zabbix agent2 a Apache — a nastaví je tak, aby se spouštěly automaticky při startu systému. Tím je zajištěno, že po dokončení instalace je celý monitoring systém připraven k použití bez nutnosti dalších zásahů.

Výsledkem je plně funkční Zabbix server dostupný na adrese http://localhost:8080/zabbix, připravený k dalšímu použití a rozšířený o monitoring SSL certifikátu školního webu na dalším hostu.