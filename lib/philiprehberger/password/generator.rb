# frozen_string_literal: true

require 'securerandom'

module Philiprehberger
  module Password
    module Generator
      LOWERCASE = ('a'..'z').to_a.freeze
      UPPERCASE = ('A'..'Z').to_a.freeze
      DIGITS = ('0'..'9').to_a.freeze
      SYMBOLS = %w[! @ # $ % ^ & * - _ + = . ? ~].freeze

      # Expanded word list (200+ words) sourced from BIP39 and EFF short wordlists.
      # All words are lowercase, 3-8 characters, easy to type and remember.
      WORD_LIST = %w[
        abandon ability able about above absent absorb abstract absurd abuse access
        account accuse achieve acid across action actor actual adapt adjust admit
        adult advance advice afford afraid again agent agree ahead aim air airport
        alarm album alert alien allow almost alone alpha already also alter always
        amateur amazing among amount amuse anchor ancient anger angle angry animal
        ankle announce annual another answer antenna antique anxiety apart apology
        appear apple approve arch arena argue armor army around arrange arrest arrive
        arrow art artist artwork ask aspect assault asset assist assume athlete atom
        attack attend auction audit august aunt author autumn average avocado avoid
        awake aware awesome awful awkward axis baby bachelor bacon badge bag balance
        balcony ball bamboo banana banner bar bargain barrel base basket battle beach
        bean beauty because become beef before begin behave behind believe below bench
        benefit best betray better between beyond bicycle bind biology bird birth
        bitter black blade blame blanket blast bleak bless blind blood blossom blue
        blur board boat body boil bomb bone bonus book border boring borrow boss
        bottom bounce box brain brand brave bread breeze brick bridge bright bring
        broken brother brown brush bubble buddy budget buffalo build bullet bundle
        burger burst bus business busy butter buyer cabin cable cactus cage cake call
        calm camera camp canal cancel cannon canvas canyon capital captain carbon card
        cargo carpet carry cart case castle casual catch cause caution cave ceiling
        celery cement census cereal certain chair chalk champion change chaos chapter
        charge chase check cheese cherry chest chicken chief child choice choose chunk
        circle citizen city civil claim clap clarify claw clay clean clerk clever
        click client cliff climb clinic clip clock close cloud clown cluster coach
        coconut code coffee coil collect color column combine comfort comic common
        company concert confirm congress connect consider control convince cool copper
        coral core correct cost cotton country couple course cousin cover craft crane
        crash crazy cream credit crew cricket crime crisp critic crop cross crouch
        crowd crucial cruel cruise crumble crush crystal cube culture cup curtain curve
        cycle damage dance danger daring dash daughter dawn debate decade december decide
        decline decorate decrease defeat define degree delay deliver demand denial depend
        deposit depth deputy derive desert design detail detect develop device devote
        diagram diamond diary diesel differ digital dignity dilemma dinner dinosaur direct
        discover disease dish dismiss display distance divert divide doctor dolphin domain
        donkey donor door dose double dove draft dragon drama drastic dream dress drift
        drink drip drive drop drum dry duck dumb dune during dust dutch dwarf dynamic
        eager eagle early earn earth easily east echo ecology edge edit educate effort
        eight either elbow elder electric elegant element elephant elite embark embrace
        emerge emotion employ empower empty enable endorse enemy energy enforce engage
        engine enhance enjoy enrich enroll entire entry envelope episode equal equip
        erase erode erosion error erupt escape essay essence estate eternal evaluate
        evening evidence evil evolve exact example excess exchange excite exclude excuse
        execute exercise exhaust exhibit exile exist expand expect expire explain expose
        express extend extra eye fabric face faculty faint faith fall famous fancy fantasy
        farm fashion father fatigue fault favorite feature federal feel female fence
        festival fetch fever fiction field figure file film filter final find finger
        finish fire firm fiscal fish fitness flag flame flash flat flavor flee flight
        flip float flock floor flower fluid flush foam focus fold follow food force
        forest forget fork fortune forum forward fossil found frame frequent fresh friend
        fringe frog front frozen fruit fuel fun funny future gadget galaxy garden garlic
        garment gather gauge gaze general genius genre gentle gesture giant gift giggle
        ginger giraffe glance glare glass globe gloom glory glove glow glue goat golden
        good gospel gossip govern gown grab grace grain grant grape grass gravity great
        grid grief grit group grow guard guess guide guitar gun gym habit half hammer
        happy harbor hard harvest hawk hazard health heart heavy hedgehog height hero
        hidden high hint hip history hobby hold hollow home hope horror horse hospital
        host hour hover hub huge human humble humor hundred hungry hurdle hurry hurt
        hybrid ice icon idea identify idle ignore image imitate immune impact impose
        improve impulse inch include income index infant initial injury inner input
        inquiry insane inside inspire install intact interest invest invite involve iron
        island isolate item ivory jacket jaguar jar jazz jealous jelly jewel job join
        joke journey judge juice jump jungle jury justice kangaroo keen keep kernel key
        kick kidney kind kingdom kitchen kite kiwi knee knife knock know label ladder
        lake lamp language laptop large later laugh laundry layer leader leaf learn leave
        lecture legend leisure lemon length lens letter level liberty library license lift
        light limb limit link liquid list little live lizard loan lobster local lonely
        loop lottery loud lounge loyal lucky lumber lunch luxury lyrics machine magic
        magnet maid major make manage mandate mango mansion maple marble margin marine
        market marriage master match material matrix maximum meadow meaning measure media
        melody member memory mention merge method middle migrate million mimic minimum
        miracle mirror misery modify moment monitor monkey monster month moral morning
        mosquito mother motion mountain mouse movie much multiply muscle museum music
        mutual mystery myth naive name napkin narrow nature neck negative neglect neither
        nephew nerve network neutral never noise normal north notable nothing novel nuclear
        number nurse object observe obtain obvious occur ocean october odor office often
        olive olympic opera opinion oppose option orange orbit orchard ordinary organ orient
        orphan ostrich other outdoor output oval oven owner oxygen oyster ozone pact paddle
        pair palace panda panel panic panther paper parade parent park patrol pattern pause
        peanut pepper perfect period permit photo phrase piano picnic picture piece pilot
        pioneer pizza planet plastic play please pledge pluck plug plunge poem point polar
        portion position possible potato pottery poverty power practice prefer prepare
        present pretty prevent pride primary print priority prison private prize problem
        process produce profit program promote proof property prosper protect proud provide
        public pulse pumpkin punch pupil purchase puzzle pyramid quality quarter question
        quick quiz quote rabbit raccoon radar rail ranch random range rapid raven razor
        ready rebel recall receive recipe record recycle reform region regular reject
        relax release relief remain remember remind render repair repeat replace require
        resist resource result retire retreat reveal rhythm rice ride rifle ring ritual
        river road robot robust rocket romance rough route royal rubber rude runway rural
        saddle safe salad salmon salon salt salute sample sand satisfy sauce sausage scale
        scatter scene school science scissors search season second secret security segment
        select senior sense sentence series service settle setup seven shadow shallow share
        shed shell sheriff shield shift shine ship shock shoot shop shoulder shove shuffle
        sibling sick side siege sight silk silver similar simple since sister sketch skill
        slender slice slim slogan slot small smile smoke smooth snake social socket solar
        soldier solution someone song source south space spare speak special spend sphere
        spider spirit split spray spread spring square stable stadium staff stage stamp
        stand start state stay steak steel stem step stick still stock stomach stone
        story strategy street strong student stuff style subject submit sugar suggest
        summer supply surface survey suspect sweet swim symbol symptom system table tackle
        talent target tattoo teach team tenant tennis tent theory thick thought three
        timber tissue title toast today together token tomato tone tongue tool toward tower
        trade traffic train transfer travel tree trend trial trigger trim trophy trouble
        truck truly trumpet trust tumble tunnel turkey turn twelve twenty twice type ugly
        umbrella unable uncle under unfair unique universe unknown unlock until unusual
        unveil update upgrade upon urban usage useful usual utility vacant valid valley
        vampire vanilla various vault vehicle velvet vendor venture version veteran viable
        village vintage violin virtual virus visual vital vivid vocal voice volcano volume
        voyage wage wagon waitress walnut warfare warm warrior water weapon weather wedding
        weekend weird welcome western whale wheat when whisper width wild window winter
        wisdom within wolf wonder world worth wreck wrestle wrist wrong yard young youth
        zebra zero zone
      ].uniq.freeze

      def self.generate(length: 16, uppercase: true, lowercase: true, digits: true, symbols: true, style: nil,
                        words: 4, separator: '-')
        case style
        when :passphrase
          generate_passphrase(words: words, separator: separator)
        when :pin
          generate_pin(length: length)
        else
          generate_random(length: length, uppercase: uppercase, lowercase: lowercase,
                          digits: digits, symbols: symbols)
        end
      end

      def self.generate_random(length:, uppercase:, lowercase:, digits:, symbols:)
        chars = []
        required = []

        if lowercase
          chars.concat(LOWERCASE)
          required << LOWERCASE
        end
        if uppercase
          chars.concat(UPPERCASE)
          required << UPPERCASE
        end
        if digits
          chars.concat(DIGITS)
          required << DIGITS
        end
        if symbols
          chars.concat(SYMBOLS)
          required << SYMBOLS
        end

        return '' if chars.empty? || length <= 0

        result = Array.new(length) { chars[SecureRandom.random_number(chars.length)] }

        # Guarantee at least one from each required class
        required.each_with_index do |char_class, i|
          break if i >= length

          result[i] = char_class[SecureRandom.random_number(char_class.length)]
        end

        result.shuffle!(random: SecureRandom)
        result.join
      end

      def self.generate_passphrase(words:, separator:)
        Array.new(words) { WORD_LIST[SecureRandom.random_number(WORD_LIST.length)] }.join(separator)
      end

      def self.generate_pin(length:)
        Array.new(length) { SecureRandom.random_number(10).to_s }.join
      end

      private_class_method :generate_random, :generate_passphrase, :generate_pin
    end
  end
end
