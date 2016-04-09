module Permalink
  def uniq_permalink_from(str)
    return if read_attribute(:permalink)
    str.strip!
    new_permalink = permalink_from(str)
    count = self.class.where(:permalink.eq => /^#{new_permalink}/).count
    new_permalink = next_permalink(str, count) if count > 0
    if self.class.where(:permalink.eq => /^#{new_permalink}/).count != 0
      new_permalink = next_permalink(str, count + 1)
    end
    write_permalink(new_permalink)
  end

  def next_permalink(str, count)
    "#{str}-#{count + 1}"
  end

  def write_permalink(str)
    write_attribute(:permalink, str)
  end

  def permalink_from(str)
    return if str.blank?
    n = str.mb_chars.downcase.to_s.strip
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
    n.gsub!(/[^\sa-z0-9_-]/,  '')
    n.gsub!(/-{2,}/,          '-')
    n.gsub!(/^-/,             '')
    n.gsub!(/-$/,             '')
    n.gsub!(/\+/,             'plus')
    n
  end
end
