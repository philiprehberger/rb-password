# frozen_string_literal: true

module Philiprehberger
  module Password
    COMMON_PASSWORDS = %w[
      123456 password 12345678 qwerty 123456789 12345 1234 111111 1234567 dragon
      123123 baseball abc123 football monkey letmein shadow master 696969 mustang
      michael shadow master 666666 qwertyuiop 123321 654321 superman qazwsx
      michael football password1 password123 batman trustno1 iloveyou sunshine
      princess access admin flower hello charlie donald passw0rd whatever
      qwerty123 654321 lovely 7777777 888888 123qwe password1 charlie
      donald robert thomas hockey ranger daniel starwars klaster george
      computer michelle jessica pepper 1111 zxcvbn tigger joshua 131313
      whatever buster hunter soccer harley batman andrew tigger sunshine
      chocolate george shadow hammer summer jordan hello amanda loveme
      family school passw0rd hockey 1q2w3e4r andrea nicole master jordan
      nothing diamond 12qwaszx welcome jennifer hunter55 carlos maggie
    ].to_set.freeze
  end
end
