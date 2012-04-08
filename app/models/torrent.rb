class Torrent < ActiveRecord::Base
  belongs_to :movie
  
  def low_seeds?
    self.seeds < 1000
  end
  
  
  def low_seeds?
    self.seeds < 1000
  end
  
  def seeds_ratio
     seeds.to_f / (seeds.to_f + leechs.to_f)
  end
  
  def low_ratio?
    seeds_ratio < 0.5
  end
  
  def dvdrip?
    !!(name =~ /.?(dvd.?rip)/i)
  end

  def brrip?
    !!(name =~ /.?(br.?rip)/i)
  end

  def bdrip?
      !!(name =~ /.?(br.?rip)/i)
  end
    
  def hd720p?
    !(brrip? or bdrip?) and !!(name =~ /.?(720p)/i)
  end
  
  def hd1080p?
    !(brrip? or bdrip?) and !!(name =~ /.?(1080p)/i)
  end
  
  
  def poor_quality?
    !(dvdrip? or brrip? or bdrip? or hd720p? or hd1080p?)
  end
  
  def find_quality
    if dvdrip?
      self.quality = 'DVD Rip'
    elsif brrip?
      self.quality = 'BR Rip'
    elsif bdrip?
      self.quality = 'BD Rip'
    elsif hd720p?
      self.quality = 'HD 720p'
    elsif hd1080p?
      self.quality = 'HD 1080p'  
    end

  end
    
  
end