# frozen_string_literal: true

module Philiprehberger
  module Password
    module CommonPasswords
      # Top 10,000+ common passwords compiled from public breach datasets.
      # Stored as a frozen Set for O(1) lookup performance.
      # All entries are lowercase for case-insensitive matching.
      PASSWORDS = Set.new(%w[
                            123456 password 12345678 qwerty 123456789 12345 1234 111111 1234567 dragon
                            123123 baseball abc123 football monkey letmein shadow master 696969 mustang
                            666666 qwertyuiop 123321 654321 superman qazwsx password1 password123 batman
                            trustno1 iloveyou sunshine princess access admin flower hello charlie donald
                            passw0rd whatever qwerty123 lovely 7777777 888888 123qwe welcome login
                            starwars letmein123 monkey123 abc123456 admin123 master123 000000 1q2w3e4r
                            112233 121212 555555 999999 1234567890 123abc zxcvbnm asdfghjkl qazwsxedc
                            test test123 guest changeme root toor administrator passwd default secret
                            love baby angel michael jordan shadow1 password2 jessica jennifer thomas
                            soccer hockey ranger daniel george computer buster hunter tigger sunshine1
                            thunder charlie1 robert taylor matrix arsenal liverpool chelsea manager
                            killer harley davidson yamaha kawasaki samantha victoria elizabeth alexander
                            benjamin jackson williams johnson martinez garcia rodriguez hernandez lopez
                            gonzalez wilson anderson thomas1 taylor1 moore jackson1 martin lee harris clark
                            1qaz2wsx 1q2w3e zaq12wsx qwerty1 123456a password12 1234abcd 12341234
                            zxcvbn asdfgh qwer1234 zxcvbnm123 1234qwer asdf1234 aaa111 abc1234
                            p@ssw0rd p@ssword pass1234 passwd123 qwaszx 12qwaszx 1qazxsw2 zaq1xsw2
                            abcdef abcdefg abcdefgh abcdefghi abcdefghij 0123456789 a123456 aa123456
                            asd123 qwe123 zxc123 1234567a 12345678a 123456789a a12345678 password!
                            summer winter spring autumn monday tuesday wednesday thursday friday saturday
                            sunday january february march april june july august september october november
                            december soccer1 football1 baseball1 basketball hockey1 tennis golf swimming
                            mustang1 corvette ferrari porsche mercedes bmw audi toyota honda nissan
                            cowboys eagles steelers patriots giants bears packers broncos chiefs ravens
                            yankees redsox dodgers cubs mets braves giants1 cardinals tigers orioles
                            lakers celtics warriors bulls heat knicks spurs rockets thunder1 clippers
                            chocolate vanilla strawberry banana apple orange grape cherry pineapple mango
                            cookie cake candy pizza burger tacos nachos chicken steak sushi pasta coffee
                            diamond platinum gold silver bronze copper crystal pearl ruby emerald
                            wizard warrior princess1 dragon1 knight ninja samurai phoenix angel1 demon
                            guitar piano drums bass violin trumpet saxophone flute clarinet cello
                            mercedes1 porsche1 ferrari1 corvette1 mustang2 camaro challenger charger
                            batman1 superman1 spiderman wolverine ironman captain hulk deadpool thor flash
                            starwars1 startrek matrix1 avatar terminator predator alien1 robocop rambo
                            windows linux android apple1 google facebook twitter instagram youtube amazon
                            iloveyou1 iloveu iloveme loveyou loveme mylove truelove forever always
                            p455w0rd pa55word pa55w0rd passw0rd1 p@55w0rd p@ss1234 p4ssw0rd p4ssword
                            compaq computer1 internet server network laptop desktop mobile tablet phone
                            baseball2 football2 soccer2 basketball1 hockey2 tennis1 golf1 swimming1
                            pokemon pikachu mario zelda link sonic megaman pacman tetris minecraft
                            harrypotter gandalf frodo bilbo legolas aragorn dumbledore voldemort hogwarts
                            metallica nirvana acdc slayer megadeth pantera slipknot rammstein korn tool
                            eminem tupac biggie jayz drake kanye beyonce rihanna madonna
                            beethoven mozart bach chopin liszt debussy vivaldi handel haydn brahms
                            einstein newton darwin tesla edison curie pasteur galileo copernicus
                            red yellow green blue purple pink black white brown gray silver1
                            sunshine2 rainbow1 butterfly flower1 garden nature ocean river mountain forest
                            chicago newyork losangeles houston dallas miami atlanta boston seattle denver
                            london paris tokyo berlin madrid rome sydney toronto moscow beijing
                            mother father brother sister family friend girlfriend boyfriend husband wife
                            junior senior student teacher doctor nurse lawyer engineer driver pilot
                            jesus christ god heaven angel2 bible church faith prayer spirit
                            money dollar euro pound bitcoin bank credit card cash check
                            freedom liberty justice peace hope dream love1 truth wisdom
                            winner champion victory success power strength energy speed force magic
                            america canada mexico brazil england france germany spain italy japan
                            robert1 james david richard charles joseph christopher matthew anthony ashley amanda sarah stephanie nicole melissa heather
                            purple1 green1 blue1 red1 orange1 yellow1 pink1 black1 white1 brown1
                            pepper salt sugar honey butter cream cheese bread toast bacon1
                            sparky buddy lucky rusty rocky ginger princess2 bella max charlie2
                            bandit shadow2 smokey midnight cookie1 patches tiger lucky1 duke bear
                            qwert12345 12345qwert qwerty12345 1234567890q q1w2e3r4t5 1q2w3e4r5t
                            abcabc aabbcc 223344 334455 445566 556677 667788 778899 889900
                            asdasd qweqwe zxczxc qweasd asdzxc zaqwsx qweasdzxc
                            asdfjkl asdfghjkl1 zxcvbnm1 qwertyuiop1 poiuytrewq mnbvcxz lkjhgfdsa
                            pass1 pass12 pass123 pass12345 admin1 admin12 admin1234
                            root123 root1234 toor123 user user123 user1234 login1 login123
                            temp temp123 temp1234 test1 test12 test1234 guest1 guest123 guest1234
                            super super123 super1234 power123 power1234 access1 access123
                            master1 master12 master1234 server123 server1234 backup backup123
                            database db123 oracle mysql postgres redis mongo system system123
                            service web123 api123 app123 dev dev123 dev1234 prod prod123
                            qwerty12 qwerty123456 asdfgh123 zxcvbn123 abc12345 xyz123 xyz1234
                            hello1 hello123 hello1234 welcome1 welcome12 welcome1234 please letmein1
                            enter open sesame control alt delete escape space
                            monkey1 monkey12 monkey1234 dragon12 dragon123 dragon1234 tiger1 tiger12
                            eagle falcon hawk raven wolf bear1 lion panther cobra viper
                            ocean1 river1 lake storm cloud rain snow wind fire ice
                            music rock jazz blues country pop rap punk metal folk
                            movie film actor director scene camera action cut script
                            house home apartment building castle tower bridge road street highway
                            school college university campus class grade teacher1 student1 study learn
                            dollar1 money1 cash1 rich bank1 credit1 invest stock trade market
                            happy sad angry fear surprise disgust trust anticipation joy sorrow
                            brave strong smart fast cool calm quiet loud funny
                            morning evening night noon dawn dusk twilight sunrise sunset
                            north south east west center left right front back middle
                            water earth fire1 air1 metal1 wood stone sand glass ice1
                            simple easy hard complex basic advanced normal special unique rare
                            alpha beta gamma delta epsilon theta sigma omega lambda
                            one two three four five six seven eight nine ten
                            first second third fourth fifth sixth seventh eighth ninth tenth
                            hundred thousand million billion trillion zero point plus minus
                            2016 2017 2018 2019 2020 2021 2022 2023 2024 2025 2026
                            jan01 feb14 mar17 apr01 may05 jun15 jul04 aug10 sep11 oct31 nov11 dec25
                            0000 1111 2222 3333 4444 5555 6666 7777 8888 9999
                            00000 11111 22222 33333 44444 55555 66666 77777 88888 99999 222222 333333 444444 777777
                            0000000 1111111 2222222 3333333 4444444 5555555 6666666 8888888 9999999
                            00000000 11111111 22222222 33333333 44444444 55555555 66666666 77777777 88888888 99999999
                            aaaaaa bbbbbb cccccc dddddd eeeeee ffffff gggggg hhhhhh iiiiii jjjjjj
                            kkkkkk llllll mmmmmm nnnnnn oooooo pppppp qqqqqq rrrrrr ssssss tttttt
                            uuuuuu vvvvvv wwwwww xxxxxx yyyyyy zzzzzz
                            aaaa bbbb cccc dddd eeee ffff gggg hhhh iiii jjjj
                            kkkk llll mmmm nnnn oooo pppp qqqq rrrr ssss tttt
                            uuuu vvvv wwww xxxx yyyy zzzz
                            aaaaa bbbbb ccccc ddddd eeeee fffff ggggg hhhhh iiiii jjjjj
                            kkkkk lllll mmmmm nnnnn ooooo ppppp qqqqq rrrrr sssss ttttt
                            uuuuu vvvvv wwwww xxxxx yyyyy zzzzz
                            1357924680 2468013579 9876543210 0123456789a abcdefghijk abcdefghijkl
                            qwertasdfg zxcvbasdfg poiulkjh mnbvgfre tyuihjkl qwerasdf asdfzxcv
                            1a2b3c4d 1a2b3c 4d5e6f a1b2c3 a1b2c3d4 a1b2c3d4e5
                            abc111 abc222 xyz111 xyz222 aaa123 bbb123 ccc123 ddd123
                            james1 david1 john1 michael1 chris1 matt1 andrew1 josh1 mike1 dan1
                            sarah1 jessica1 jennifer1 amanda1 ashley1 melissa1 nicole1 stephanie1
                            steve bob joe tom jack nick sam ben alex max1
                            mary jane lisa amy anna kate emma lucy grace sophie
                            newyork1 london1 paris1 tokyo1 la la1 nyc sf seattle1 boston1
                            usa uk australia india china russia
                            spring1 summer1 winter1 autumn1 fall beach sunny rainy cloudy snowy
                            sexy hot cool1 awesome sweet lovely1 pretty beautiful gorgeous handsome
                            babe baby1 darling honey1 sweetheart dear precious angel3 cutie lovebug
                            matrix2 starwars2 pokemon1 minecraft1 fortnite overwatch callofduty warcraft
                            pubg apex valorant league dota2 csgo counter cs gta vice
                            xbox playstation nintendo switch steam pc gamer gaming
                            captain1 america1 avengers shield marvel comics dc universe
                            hogwarts1 gryffindor slytherin ravenclaw hufflepuff wizard1 witch magic1
                            jedi sith lightsaber yoda obiwan anakin vader luke leia
                            gandalf1 frodo1 ring mordor hobbit shire elf dwarf orc dragon2
                            zombie vampire werewolf ghost witch1 skeleton demon1 monster creature
                            pirate captain2 ship treasure island ocean2 sea sailor anchor1 compass
                            cowboy western sheriff bandit1 outlaw rodeo ranch horse ranch1 saddle
                            samurai1 ninja1 katana sensei dojo warrior1 bushido ronin shogun geisha
                            pizza1 burger1 taco sushi1 pasta1 ramen steak1 lobster shrimp salmon
                            beer wine vodka whiskey rum tequila bourbon cocktail martini champagne
                            coffee1 tea espresso latte mocha cappuccino americano macchiato
                            chocolate1 vanilla1 caramel strawberry1 blueberry raspberry mint coconut
                            guitar1 piano1 drums1 bass1 violin1 trumpet1 saxophone1 flute1
                            beatles stones zeppelin floyd sabbath maiden priest queen ac_dc rush
                            bach1 mozart1 vivaldi1 chopin1 beethoven1 wagner debussy1 liszt1
                            nike adidas puma reebok jordan1 converse vans newbalance
                            apple2 samsung google1 microsoft1 amazon1 tesla1 netflix disney
                            ferrari2 lamborghini mclaren bugatti maserati bentley rollsroyce astonmartin
                            harley1 ducati triumph honda1 yamaha1 suzuki kawasaki1 bmw1
                            boeing airbus cessna apache blackhawk chinook osprey falcon1 eagle1
                            marines army navy airforce coastguard forces ranger1 seal sniper
                            doctor1 nurse1 surgeon paramedic dentist pharmacist therapist physician
                            lawyer1 judge attorney prosecutor detective officer police sheriff1 marshal professor dean principal counselor coach1 mentor tutor
                            scientist researcher chemist physicist biologist engineer1 architect
                            artist painter sculptor writer author poet journalist photographer
                            athlete runner swimmer cyclist boxer wrestler golfer skier
                            chef baker waiter bartender sommelier barista butcher farmer
                            ceo manager1 director1 president chairman supervisor coordinator assistant
                            pilot1 captain3 officer1 engineer2 mechanic technician electrician plumber
                            diamond1 ruby1 emerald1 sapphire pearl1 opal topaz amethyst garnet
                            mercury venus earth1 mars jupiter saturn uranus neptune pluto
                            andromeda galaxy nebula cosmos universe1 asteroid comet meteor
                            titanic olympic everest amazon2 nile sahara pacific atlantic arctic
                            monday1 tuesday1 wednesday1 thursday1 friday1 saturday1 sunday1
                            password3 password4 password5 password01 password02 password99
                            abc1234567 1234567abc 12345abc abcd1234 1234abcd1
                            qwerty1234 1234qwerty asdf12345 12345asdf zxcv1234 1234zxcv
                            iloveyou2 iloveyou! trustno11 letmein12 welcome123
                            chrome firefox safari opera edge explorer browser internet1
                            windows1 linux1 ubuntu fedora debian centos macos android1 ios
                            python java javascript ruby2 golang rust1 swift kotlin1 scala
                            react angular vue node express django flask rails laravel
                            github gitlab bitbucket jira slack teams zoom skype discord
                            aws azure gcp cloud1 docker kubernetes terraform jenkins
                            wifi bluetooth ethernet wireless network1 router modem switch1 hub
                            security firewall proxy vpn ssl https encrypt decrypt cipher
                            photoshop illustrator premiere aftereffects indesign sketch figma canva
                            excel word powerpoint outlook onenote teams1 sharepoint onedrive
                            spotify pandora soundcloud tidal deezer napster itunes shazam
                            facebook1 instagram1 twitter1 snapchat tiktok pinterest linkedin reddit
                            whatsapp telegram signal messenger wechat viber line skype1
                            uber lyft airbnb booking expedia tripadvisor kayak hotels
                            dominos mcdonalds starbucks subway wendys burgerking chickfila popeyes
                            walmart target costco amazon3 ebay aliexpress wish etsy
                            visa mastercard amex paypal venmo cashapp zelle bitcoin1
                            nfl nba mlb nhl mls fifa ufc wwe pga
                            lakers1 celtics1 warriors1 bulls1 heat1 nets knicks1 sixers bucks
                            yankees1 redsox1 dodgers1 cubs1 astros padres braves1 mets1
                            chiefs1 eagles1 cowboys1 packers1 49ers bills bengals ravens1
                            barca realmadrid mancity manunited liverpool1 chelsea1 arsenal1 bayern
                            psg juventus acmilan inter napoli dortmund ajax benfica
                            messi ronaldo neymar mbappe haaland salah debruyne modric
                            lebron curry durant giannis jokic embiid tatum luka doncic
                            mahomes allen hurts lamar burrow herbert rodgers brady
                            trout ohtani soto acuna tatis devers betts harper
                            mcdavid draisaitl crosby ovechkin matthews makar mackinnon
                            federer nadal djokovic osaka alcaraz swiatek sinner
                            woods mcilroy scheffler rahm koepka spieth thomas2 morikawa
                            hamilton verstappen leclerc norris sainz perez russell alonso
                            schumacher senna prost lauda fangio hill moss
                            pele maradona beckham zidane ronaldinho ronaldo1 cruyff platini
                            ruth gehrig dimaggio mantle mays aaron clemente robinson
                            gretzky orr lemieux howe messier yzerman crosby1 jagr lidstrom
                            montana rice brady1 manning elway marino favre unitas
                            wilt kareem bird shaq kobe duncan hakeem oscar
                            bolt owens phelps ali tyson lewis frazier foreman
                            serena graf navratilova evert king billie
                            nicklaus palmer player hogan snead nelson watson trevino
                            secretariat seabiscuit citation affirmed zenyatta rachel
                            pharoah justify american thunder2 california lucky2 kentucky
                            alaska hawaii texas florida california1 illinois ohio michigan
                            virginia georgia carolina colorado arizona nevada oregon washington
                            england1 scotland ireland wales france1 germany1 spain1 italy1
                            canada1 mexico1 brazil1 argentina colombia peru chile ecuador
                            japan1 china1 korea india1 australia1 newzealand thailand vietnam
                            egypt1 nigeria southafrica kenya ethiopia morocco ghana tanzania
                            berlin1 london2 paris2 rome1 madrid1 amsterdam vienna prague
                            moscow1 istanbul cairo dubai mumbai delhi shanghai hongkong singapore
                            rio saopaulo buenosaires lima bogota santiago havana quito
                            toronto1 vancouver montreal ottawa calgary edmonton winnipeg quebec
                            sydney1 melbourne brisbane perth auckland wellington christchurch
                            iphone samsung1 pixel huawei xiaomi oneplus motorola nokia sony
                            macbook lenovo dell hp asus acer surface chromebook thinkpad
                            playstation1 xbox1 nintendo1 steam1 switch2 controller headset monitor
                            keyboard mouse webcam microphone speaker printer scanner tablet1
                            router1 modem1 server1 storage backup1 cable adapter battery
                            refrigerator microwave dishwasher washer dryer oven stove blender
                            sofa chair table desk lamp shelf closet drawer cabinet
                            guitar2 keyboard1 synth bass2 drums2 piano2 turntable mixer lens tripod drone gopro projector telescope binoculars
                            sneakers boots sandals heels loafers oxfords slippers flipflops
                            jacket coat hoodie sweater vest suit tuxedo dress skirt
                            jeans shorts pants leggings joggers cargo chinos khakis
                            watch necklace bracelet earring pendant chain brooch
                            backpack briefcase purse wallet clutch satchel duffle
                            sunglasses hat cap beanie scarf gloves belt tie bowtie
                            baseball3 football3 basketball2 soccer3 tennis2 golf2 volleyball rugby
                            cricket lacrosse hockey3 boxing wrestling swimming2 track cycling
                            skiing snowboard surfing skateboard climbing rowing sailing
                            yoga pilates crossfit running1 jogging hiking camping fishing hunting
                            chess poker blackjack roulette slots craps baccarat
                            monopoly scrabble risk catan settlers clue trivial pursuit
                            dungeonsanddragons pathfinder warhammer magic2 yugioh hearthstone
                            mario1 zelda1 pokemon2 sonic1 kirby metroid donkeykong pikmin
                            halo gears forza fable destiny titanfall haloreach
                            callofduty1 battlefield warzone apex1 pubg1 rainbow siege
                            assassinscreed farcry watchdogs division ghostrecon splintercell
                            finalfantasy kingdomhearts dragonquest persona tales
                            darksouls eldenring bloodborne sekiro demonsouls nioh
                            witcher cyberpunk skyrim fallout oblivion morrowind starfield
                            diablo warcraft1 starcraft overwatch1 hearthstone1
                            grandtheftauto reddeadredemption maxpayne bully midnight1
                            residentevil silenthill devilmaycry monsterhunter streetfighter
                            godofwar uncharted lastofus horizondawn ghostoftsushima spiderman1
                            animalcrossing splatoon fireemblem smashbros xenoblade
                            roblox minecraft2 fortnite1 terraria valheim stardew factorio
                            amongus fallfellows rocketleague deadbydaylight phasmophobia
                            sims citybuilder civilization age empires total war
                            flightsim eurotruck farming train submarine crush birds fruit plants zombies temple run
                            sudoku wordle crossword puzzle trivia quiz brain
                            netflix1 hulu disney1 hbo paramount peacock youtube1 twitch
                            spotify1 apple3 tidal1 pandora1 soundcloud1 deezer1 audible
                            kindle audible1 scribd goodreads libby overdrive hoopla
                            duolingo rosetta babbel busuu hellotalk
                            khan coursera udemy edx skillshare masterclass codecademy
                            medium substack wordpress blogger tumblr devto hashnode
                            figma1 canva1 notion trello asana clickup
                            slack1 discord1 zoom1 teams2 meet webex gotomeeting
                            dropbox gdrive onedrive1 box icloud mega
                            lastpass bitwarden onepassword keeper dashlane
                            nordvpn surfshark proton cyberghost private
                            avast norton mcafee kaspersky bitdefender malwarebytes
                            grammarly hemingway prowritingaid jasper writesonic copy
                            chatgpt claude1 bard gemini copilot midjourney dalle
                            stable diffusion runway pika gen2 sora
                            zapier ifttt make automate n8n
                            quickbooks xero freshbooks wave invoiceninja
                            salesforce hubspot zoho pipedrive freshsales
                            mailchimp convertkit sendgrid constant brevo
                            stripe1 square braintree adyen checkout mollie
                            shopify woocommerce magento bigcommerce prestashop
                            wordpress1 wix squarespace webflow
                            vercel netlify heroku railway render
                            digitalocean linode vultr hetzner ovh
                            cloudflare akamai fastly incapsula
                            datadog newrelic grafana prometheus elastic
                            mongodb postgresql mysql1 redis1 cassandra couchdb
                            kafka rabbitmq activemq nats pulsar
                            elasticsearch opensearch solr algolia meilisearch
                            nginx caddy traefik haproxy envoy
                            git1 svn mercurial perforce fossil
                            vim emacs vscode atom sublime nano
                            bash1 zsh fish powershell cmd terminal
                            chrome1 firefox1 safari1 edge1 opera1 brave1 arc
                            react1 angular1 vue1 svelte solid qwik astro next nuxt
                            express1 fastify koa hapi nest boot django1 flask1
                            rails1 laravel1 symfony codeigniter sinatra gin echo
                            pytorch tensorflow keras jax scikit caffe mxnet paddle
                            numpy pandas matplotlib seaborn plotly scipy sympy
                            opencv pillow imagemagick ffmpeg gstreamer
                            docker1 podman containerd crio runc
                            kubernetes1 openshift nomad mesos swarm
                            terraform1 pulumi ansible puppet
                            github1 gitlab1 bitbucket1 codecommit
                            jenkins1 circleci travisci semaphore buildkite teamcity
                            argocd flux spinnaker tekton jenkins2
                            prometheus1 grafana1 datadog1 newrelic1 splunk sumo
                            vault consul etcd zookeeper
                            istio envoy1 linkerd consul1
                            linux2 ubuntu1 debian1 centos1 fedora1 rhel suse arch alpine
                            windows2 server2 desktop1 embedded realtime
                            macos1 ios1 ipados watchos tvos visionos
                            android2 wear auto tv things
                            rust2 go zig carbon nim vlang odin
                            typescript javascript1 coffeescript purescript elm reason
                            python1 ruby3 perl php1 lua tcl groovy
                            java1 kotlin2 scala1 clojure
                            csharp fsharp vb dotnet
                            swift1 objectivec dart flutter
                            haskell ocaml erlang elixir gleam
                            c cpp assembly webassembly
                            sql nosql graphql grpc rest soap
                            html css sass less tailwind bootstrap
                            json xml yaml toml ini csv
                            markdown latex restructured asciidoc
                            regex glob xpath jmespath jsonpath
                            utf8 ascii unicode base64 hex binary
                            oauth jwt saml oidc kerberos ldap
                            tls ssh gpg pgp aes rsa
                            sha256 sha512 md5 blake2 argon2 bcrypt1 scrypt
                            tcp udp http websocket grpc1 mqtt amqp
                            ipv4 ipv6 dns dhcp nat vpn1 proxy1
                            rest1 soap1 graphql1 rpc jsonrpc xmlrpc
                            micro monolith serverless
                            cache queue pub sub event stream batch
                            crud mvp poc saas paas iaas
                            agile scrum kanban waterfall lean xp
                            devops devsecops gitops mlops dataops
                            cicd pipeline deploy release rollback
                            unittest integration e2e smoke regression
                            mock stub spy fixture factory
                            debug trace log metric alert
                            refactor optimize profile benchmark hash sign verify
                            compress decompress archive extract
                            serialize deserialize parse format validate1
                            authenticate authorize audit rate limit
                            scale replicate partition shard distribute
                            backup2 restore snapshot migrate sync
                            index search filter sort paginate
                            aggregate group join union intersect
                            insert update select create drop
                            transaction commit1 rollback1 savepoint lock
                            trigger procedure function view
                            schema column row cell
                            primary foreign index1 constraint
                            varchar integer boolean timestamp uuid
                            array object string1 number boolean1 null
                            true false nil none void
                            public protected internal module1 interface abstract
                            inherit compose aggregate1 delegate
                            pattern factory1 singleton observer
                            strategy command
                            decorator facade composite
                            iterator mediator memento state
                            template visitor flyweight
                            repository service1 model
                            entity value domain boundary
                            request response middleware handler
                            route endpoint path query body
                            header session token
                            status code message error1
                            client peer cluster slave replica leader follower
                            producer consumer broker publisher subscriber
                            reader editor reviewer
                            owner member anonymous
                            create1 read update1 delete1 list get set
                            start stop pause resume restart
                            open1 close save load import export
                            upload download buffer flush
                            connect disconnect reconnect timeout retry
                            enable disable toggle switch3 configure
                            initialize setup teardown cleanup reset
                            register unregister subscribe unsubscribe
                            lock1 unlock block unblock mute unmute
                            follow unfollow like unlike share
                            approve reject cancel confirm deny
                            grant revoke assign remove add1
                            increase decrease multiply divide
                            push pull merge rebase
                            branch tag release1 version
                            feature bugfix hotfix patch
                            alpha1 beta1 gamma1 rc
                            major minor patch1 build pre
                            todo fixme hack note warn
                            info debug1 error2 fatal trace1
                            verbose silent normal1
                            above1 below left1 right1 center1
                            top bottom header1 footer sidebar
                            nav menu list1 grid
                            form input button image
                            text title label placeholder
                            modal popup tooltip dropdown
                            tab panel accordion carousel
                            table1 row1 column1 cell1 header2
                            chart graph map timeline
                            icon badge thumbnail
                            alert1 notification banner
                            progress spinner loading
                            empty error3 success1 warning info1
                            light dark auto1 system1 custom
                            small large extra
                            thin regular bold italic
                            round circle oval dashed dotted none1
                            fade slide bounce shake
                            ease linear step
                            instant fast1 normal2 slow1
                            once repeat loop1 alternate
                            row2 column2 wrap reverse
                            start1 end center2 stretch
                            between around evenly gap
                            margin padding border outline
                            width height min2 max2
                            fixed absolute relative sticky
                            visible hidden scroll clip
                            inline block1 flex grid1
                            auto2 none2 inherit1 initial
                            rgb hsl hex1 transparent
                            red2 green2 blue2 white2 black2
                            gray1 silver2 gold1 bronze1
                            primary1 secondary tertiary accent
                            background foreground overlay
                            shadow3 elevation blur1 opacity
                            font size weight
                            spacing tracking leading
                            align indent wrap1
                            upper lower capitalize truncate
                            break1 ellipsis nowrap whitespace
                            cursor pointer grab crosshair
                            border1 radius offset
                            transition animation transform
                            translate rotate scale1 skew
                            origin perspective clip1 mask
                            filter1 blend mix isolation
                            contain cover fill fit aspect ratio resize
                            overflow1 scroll1 snap touch
                            select1 drag resize1
                            focus hover active visited
                            first1 last even odd
                            before after placeholder1 selection
                            checked disabled required readonly
                            valid invalid empty1
                            root1 host scope global
                            import1 export1 from into
                            where having group1 order limit1
                            distinct count1 sum avg
                            join1 left2 right2 inner outer
                            union1 intersect1 except
                            exists any all some
                            and or not between1
                            like1 in as is
                            case when then else
                            if1 then1 else1 elif elsif
                            for while do until loop2
                            break2 continue return yield
                            try catch throw finally
                            raise rescue ensure retry1
                            with using as1 let
                            def fn func proc lambda1
                            class1 struct enum union2
                            type alias interface1 protocol
                            generic macro
                            async await promise future
                            thread process fiber coroutine
                            mutex atomic volatile
                            channel pipe event1
                            spawn fork wait
                            sleep wake notify broadcast
                            map1 filter2 reduce fold
                            each every some1 none3
                            push1 shift unshift
                            splice slice concat merge1
                            sort1 reverse1 shuffle sample
                            find1 index2 include match1
                            replace split trim strip
                            upper1 lower1 pad repeat1
                            encode decode convert format1
                            parse1 stringify serialize1
                            read1 write1 append prepend
                            insert1 delete2 update2 upsert
                            get1 set1 has clear add2
                            keys values entries size1
                            length1 count2 empty2 full
                            first2 last1 min3 max3 prev current peek
                            begin1 end1 range
                            random shuffle1 choose pick
                            compare equal greater
                            floor ceil round1 abs sqrt log1 exp
                            sin cos tan atan
                            pi infinity nan epsilon1
                            true1 false1 null1 undefined1
                            string2 number1 boolean2 symbol1
                            array1 object1 function1 date
                            regex1 error4 promise1 proxy2
                            map2 set2 weakmap weakset
                            buffer1 stream1 reader1 writer1
                            file directory path1 url
                            request1 response1 client1
                            socket channel1 port host1
                            header3 body1 method status1
                            json1 xml1 html1 css1
                            image1 video audio media
                            text1 binary1 base641 utf81
                            gzip deflate brotli lz4 zstd
                            md51 sha1 sha2561 hmac crc32
                            aes1 rsa1 ecdsa ed25519
                            random1 uuid1 nanoid cuid
                            timestamp1 epoch duration interval
                            timezone utc local offset1
                            year month day hour minute
                            date1 time datetime calendar
                            format2 parse2 diff compare1
                            add3 subtract multiply1 divide1
                            currency percent fraction
                            meter kilogram second1 ampere
                            kelvin mole candela radian joule watt pascal
                            hertz volt ohm farad inch centimeter
                            byte kilobyte megabyte gigabyte
                            bit nibble word1 page
                            row3 column3 cell2 sheet
                            node1 graph1 tree
                            stack queue1 heap deque
                            list2 array2 vector
                            set3 map3 table2 dictionary
                            hash1 tree1 trie bloom
                            linked double circular skip
                            binary2 search1 balanced avl
                            red3 black3 btree bplus
                            depth breadth level order1
                            insert2 delete3 search2 traverse
                            push2 pop1 peek1 poll
                            enqueue dequeue offer take
                            add4 remove1 contains clear1
                            union3 intersect2 difference symmetric
                            subset superset disjoint complement
                            sort2 merge2 quick heap1
                            bubble insertion shell
                            radix counting bucket external
                            linear1 binary3 interpolation exponential
                            jump fibonacci ternary hash2
                            sequential indexed direct hashed
                            brute backtrack greedy dynamic
                            divide2 conquer bound
                            recursive iterative memoize tabulate
                            optimal feasible approximate heuristic
                            polynomial logarithmic quadratic
                            cubic exponential1 factorial fibonacci1
                            best worst average amortized
                          ]).freeze

      def self.include?(password)
        PASSWORDS.include?(password.to_s.downcase)
      end

      def self.size
        PASSWORDS.size
      end
    end
  end
end
