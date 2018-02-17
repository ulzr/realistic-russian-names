Description
-----------

A relatively large collection of russian first, last names and patronymics, information on their popularity and utilities for making their derivatives. With this gem you can form pretty realistic lists of russian names.

Install
-------

You need [Ruby 1.9.3](http://ruby-lang.org/) or higher to use this gem.

    $ gem install realistic-russian-names

Usage
-----

Example:

    require 'realistic_russian_names'
    
    puts realistic_russian_male_last_names.sample
      #=> Иванов
    puts russian_female_last_name(realistic_russian_male_last_names.sample)
      #=> Сидорова

You may also use the executable:

    $ gen-realistic-russian-names -n 3
    Кирьяков Анатолий Алексеевич
    Захарова Алина Олеговна
    Бажуков Максим Ильич

Run `gen-realistic-russian-names -h` for details.

### Performance notes ###

The example above loads all the data at once. You may “require” separate methods to reduce memory usage:

    require 'realistic_russian_male_first_names'
    
    puts realistic_russian_male_first_names.sample
      #=> Артём
