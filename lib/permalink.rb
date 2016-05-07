module Permalink
  def uniq_permalink_from(str)
    return if read_attribute(:permalink)
    new_permalink = permalink_from(str)
    count = self.class.where(:permalink.eq => /^#{new_permalink}-?.*/).count
    new_permalink = next_permalink(new_permalink, count) if count > 0
    write_permalink(new_permalink)
  end

  def next_permalink(str, count)
    "#{str}-#{count}"
  end

  def write_permalink(str)
    write_attribute(:permalink, str)
  end

  def permalink_from(str)
    return if str.blank?
    n = str.mb_chars.to_s
    n.gsub!(/\+/,             'plus')
    n.gsub!(/\#/,             'sharp')
    n.gsub!(/[\/\\]/,         '-')
    n.gsub!(/\d/) { |number| in_words(number.to_i) }
    n.gsub!(/[àáâãäåāă]/,     'a')
    n.gsub!(/æ/,              'ae')
    n.gsub!(/[ďđ]/,           'd')
    n.gsub!(/[çćčĉċ]/,        'c')
    n.gsub!(/[èéêëēęěĕė]/,    'e')
    n.gsub!(/ƒ/,              'f')
    n.gsub!(/[ĝğġģ]/,         'g')
    n.gsub!(/[ĥħ]/,           'h')
    n.gsub!(/[ììíîïīĩĭ]/,     'i')
    n.gsub!(/[įıĳĵ]/,         'j')
    n.gsub!(/[ķĸ]/,           'k')
    n.gsub!(/[łľĺļŀ]/,        'l')
    n.gsub!(/[ñńňņŉŋ]/,       'n')
    n.gsub!(/[òóôõöøōőŏŏ]/,   'o')
    n.gsub!(/œ/,              'oe')
    n.gsub!(/ą/,              'q')
    n.gsub!(/[ŕřŗ]/,          'r')
    n.gsub!(/[śšşŝș]/,        's')
    n.gsub!(/[ťţŧț]/,         't')
    n.gsub!(/[ùúûüūůűŭũų]/,   'u')
    n.gsub!(/ŵ/,              'w')
    n.gsub!(/[ýÿŷ]/,          'y')
    n.gsub!(/[žżź]/,          'z')
    n.gsub!(/\s+/,            '-')
    n.gsub!(/-{2,}/,          '-')
    n.gsub!(/^-/,             '')
    n.gsub!(/-$/,             '')

    n.downcase
  end

  def in_words(int)
    numbers_to_name = {
      1_000_000 => 'million',
      1000 => 'thousand',
      100 => 'hundred',
      90 => 'ninety',
      80 => 'eighty',
      70 => 'seventy',
      60 => 'sixty',
      50 => 'fifty',
      40 => 'forty',
      30 => 'thirty',
      20 => 'twenty',
      19 => 'nineteen',
      18 => 'eighteen',
      17 => 'seventeen',
      16 => 'sixteen',
      15 => 'fifteen',
      14 => 'fourteen',
      13 => 'thirteen',
      12 => 'twelve',
      11 => 'eleven',
      10 => 'ten',
      9 => 'nine',
      8 => 'eight',
      7 => 'seven',
      6 => 'six',
      5 => 'five',
      4 => 'four',
      3 => 'three',
      2 => 'two',
      1 => 'one'
    }
    str = ''
    numbers_to_name.each do |num, name|
      if int == 0
        return str
      elsif int.to_s.length == 1 && int / num > 0
        return str + "#{name}"
      elsif int < 100 && int / num > 0
        return str + "#{name}" if int % num == 0
        return str + "#{name} " + in_words(int % num)
      elsif int / num > 0
        return str + in_words(int / num) + " #{name} " + in_words(int % num)
      end
    end
  end
end
