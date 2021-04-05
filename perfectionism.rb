# 由于Sonic Pi不支持通过相对路径读取样本文件，请修改下面路径为源代码文件所在目录！

SAMPLE_DIR = "C:/Users/Ross/Google Drive/sonic-pi"


grand_piano = SAMPLE_DIR + "/grand_piano"
strings = SAMPLE_DIR + "/strings"
pluck_bass = SAMPLE_DIR + "/pluck_bass"

use_bpm 90
set_volume! 2


def play_sample(instrument, notes, sustain, amp: 0.5, release: 0.5, attack: 0)
  if !notes.kind_of?(Array) then
    notes = [notes]
  end
  
  notes.each do |note|
    base_note = ((note(note) - note(:c0)) / 12.0).round()
    wave_file = "%s/c%d.ogg" % [instrument, base_note]
    pitch_offset = note(note) - (base_note * 12 + note(:c0))
    
    sample wave_file, rpitch: pitch_offset, sustain: bt(sustain), release: release, amp: amp, attack: attack
  end
end


define :bass1 do
  use_synth :sine
  with_fx :hpf, cutoff: 30 do
    with_fx :distortion, distort: 0.45 do
      play :d2, attack: 0, sustain: 0.3, amp: 0.5
      sleep 2
      play :g1, attack: 0, sustain: 0.15, amp: 0.8
      sleep 1.5
      play :g1, attack: 0, sustain: 0.15, amp: 0.8
      sleep 0.5
    end
  end
end


define :bass_prechorus do |repeat=0|
  notes = [:Bb4, :Bb4, :G4, :A4, :F4, :Db4, :Db5, :Bb4, :A4, :F4, :D4, :D5, :C5, :C5,
           :Bb4, :Bb4, :G4, :A4, :F4, :Db4, :Db5, :Bb4, :A4, :F4, :D4]
  duration =  [0.75, 0.5, 0.25, 0.25, 0.25, 0.75, 0.5, 0.25, 0.25, 0.25, 2, 0.25, 0.5, 1.25,
               0.75, 0.5, 0.25, 0.25, 0.25, 0.75, 0.5, 0.25, 0.25, 0.25, 4]
  notes.zip(duration).all? do |note, duration|
    play_sample pluck_bass, note, duration, amp: 2
    sleep duration
  end
end


define :base_chorus1 do
  notes = [:d5, :d5, :d5, :d5, :d5, :g4, :a4, :g4, :a4, :a4, :a4, :a4, :a4, :d5, :a4]
  durations = [0.75, 1.75, 0.5, 0.5, 0.5, 2.5, 0.5, 0.5, 0.5, 2.5, 0.5, 0.5, 0.5, 2, 2]
  
  with_fx :distortion, mix: 0.3 do
    notes.zip(durations).all? do |note, duration|
      play_sample pluck_bass, note, duration * 0.5, amp: 2
      sleep duration
    end
  end
end


define :base_chorus2 do
  notes = [:d5, :d5, :d5, :d5, :d5, :g4, :a4, :g4, :a4, :a4, :a4, :a4, :a4, :bb4]
  durations = [0.75, 1.75, 0.5, 0.5, 0.5, 2.5, 0.5, 0.5, 0.5, 2.5, 0.5, 0.5, 0.5, 4]
  
  with_fx :distortion, mix: 0.3 do
    notes.zip(durations).all? do |note, duration|
      play_sample pluck_bass, note, duration * 0.5, amp: 2
      sleep duration
    end
  end
end


define :shutter do
  sleep 1.5
  sample SAMPLE_DIR + "/shutter.ogg", amp: 1.2
  sleep 0.5
  sample SAMPLE_DIR + "/shutter.ogg", amp: 1.2
  sleep 2
end


define :piano_prelude do |lower_octive=false|
  with_fx :eq, high: 0.3 do
    with_fx :reverb, room: 0.1, mix: 0 do
      with_fx :echo, mix: 0 do
        
        use_synth :piano
        
        notes = [:d4, :a4, :d5, :f5, :e5, :d5,
                 :g4, :bb4, :d5, :e5, :a5, :f5,
                 :d4, :a4, :d5, :f5, :d5, :a4,
                 :g4, :bb4, :d5, :e5, :a5, :f5]
        
        duration = [0.5, 0.25, 0.5, 0.25, 0.25, 0.25,
                    0.25, 0.25, 0.25, 0.25, 0.5, 0.5,
                    0.5, 0.25, 0.5, 0.25, 0.25, 0.25,
                    0.25, 0.25, 0.25, 0.25, 0.5, 0.5]
        
        in_thread {
          notes.zip(duration).all? do |note, duration|
            play_sample grand_piano, lower_octive ? note - 12 : note, duration * 0.6, amp: 0.3
            sleep duration
          end
        }
        in_thread {
          play_sample grand_piano, :d4, 1, amp: 0.1
          sleep 2
          play_sample grand_piano, :g4, 1, amp: 0.1
          sleep 2
          play_sample grand_piano, :d4, 1, amp: 0.1
          sleep 2
          play_sample grand_piano, :g3, 1, amp: 0.1
          sleep 2
        }
        sleep 8
      end
    end
  end
end


define :piano_prelude_arp do
  with_fx :reverb, room: 0.2, mix: 0.5 do
    with_fx :echo, mix: 0 do
      use_synth :piano
      
      sleep 0.5
      notes = [:a4, :g4, :f4, :e4, :d4, :db4]
      duration = [0.25, 0.25, 0.25, 0.25, 0.25, 0.25]
      
      sleep 2
      notes.zip(duration).all? do |note, duration|
        play_sample grand_piano, note, 0.3, amp: 0.15
        sleep duration
      end
    end
  end
end


define :hihat do
  16.times do
    sample SAMPLE_DIR + "/808_hihat.ogg", amp: 0.5
    sleep 0.25
  end
end


define :hihat_fast do
  8.times do
    sample SAMPLE_DIR + "/808_hihat.ogg", amp: 0.25
    sleep 0.125
  end
end


define :snare1 do
  at [1, 2.25, 2.75, 3.25, 3.75] do
    sample SAMPLE_DIR + "/rim.ogg", amp: 0.8
  end
  sleep 4
end


define :snare2 do
  at [1, 2.25, 2.75, 3.25] do
    sample SAMPLE_DIR + "/rim.ogg", amp: 0.8
  end
  sleep 4
end


define :clap do
  at [1, 3] do
    sample SAMPLE_DIR + "/clap.ogg", amp: 0.8
  end
  sleep 4
end


define :kick1 do
  at [0, 3.75] do
    sample SAMPLE_DIR + "/kick.ogg", amp: 0.6
  end
  sleep 4
end


define :kick2 do
  at [0, 2.75, 3.25, 3.75] do
    sample SAMPLE_DIR + "/kick.ogg", amp: 0.6
  end
  sleep 4
end


define :kick_fast do
  8.times do
    sample SAMPLE_DIR + "/kick.ogg", amp: 0.5
    sleep 0.125
  end
end


define :piano_verse_arp do
  use_synth :piano
  with_fx :reverb do
    play_pattern_timed [:F4, :D5, :E4, :C5, :D4, :Bb4, :C4, :A4],
      [0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25], amp: 0.4
  end
end


define :piano_prechorus_arp do
  use_synth :piano
  with_fx :eq, high: 0.5 do
    with_fx :reverb, mix: 0.5 do
      sleep 0.5
      play_pattern_timed [:d5, :f5, :a5, :d6, :a5, :f5,
                          :db6, :bb5, :g5, :e5, :db5, :bb4, :g4,
                          :d5, :f5, :a4, :d5, :a5, :f5, :d5,
                          :f5, :d5, :f5, :a4, :d5, :a5, :f5,
                          :d5, :f5, :a5, :d6, :a5, :f5,
                          :db6, :bb5, :g5, :e5, :db5, :bb4, :g4,
      :d5, :f5, :a4, :d5, :a5, :f5, :d5],
        [0.25, 0.25, 0.25, 0.25, 0.25, 0.5,
         0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
         0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.75,
         0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.75,
         0.25, 0.25, 0.25, 0.25, 0.25, 0.5,
         0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
         0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.75], amp: 0.2
    end
  end
end


define :strings_prelude1 do
  with_fx :reverb do
    play_sample strings, :d5, 1.8, amp: 0.05
    play_sample strings, :f4, 1.8, amp: 0.05
    sleep 2
    play_sample strings, :g4, 1.1, amp: 0.08
    play_sample strings, :bb3, 1.1, amp: 0.08
    sleep 2
  end
end


define :strings_prelude2 do
  play_sample strings, :f3, 1.8, amp: 0.2
  play_sample strings, :d2, 1.8, amp: 0.2
  sleep 2
  play_sample strings, :bb2, 1.2, amp: 0.2
  play_sample strings, :g1, 1.2, amp: 0.2
  sleep 2
end


define :strings_ending do
  play_sample strings, :d3, 4, amp: 0.1
  play_sample strings, :a2, 4, amp: 0.1
  play_sample strings, :f2, 4, amp: 0.1
  play_sample strings, :d2, 4, amp: 0.1
  sleep 2
end


define :strings_prechorus do
  chords = [[:a2, :a3],
            [:d2, :d3, :d4],
            [:a2, :a3],
            [:d2, :d3, :d4]]
  durations = [4, 4, 4, 2]
  
  chords.zip(durations).all? do |chord, duration|
    play_sample strings, chord, duration * 0.5, release: 1, amp: 0.1, attack: 1
    sleep duration
  end
end


define :strings_chorus do
  chords = [[:d2, :a2, :d3, :f3],
            [:g1, :bb2, :d3, :f3],
            [:a1, :g2, :bb2, :e3],
            [:d2, :a2, :d3, :f3],
            [:a1, :g2, :bb2, :e3]]
  durations = [4, 4, 4, 2, 2]
  
  chords.zip(durations).all? do |chord, duration|
    play_sample strings, chord, duration, amp: 0.1
    sleep duration
  end
end

define :strings_drop do
  notes = [:f5, :g5, :f5, :g5, :f5, :g5, :f5, :g5, :f5, :g5, :f5, :g5, :f5, :g5, :f5,
           :g5, :e5, :d5, :db5, :bb4, :a4, :g4, :e4, :d4, :db4, :bb3, :a3]
  durations = [0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.25,
               0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15, 0.15]
  
  notes.zip(durations).all? do |note, duration|
    play_sample strings, note, duration * 0.8, amp: 0.2, release: 0.3
    sleep duration
  end
end


define :bell_chorus do
  use_synth :pretty_bell
  with_fx :lpf, cutoff: 80 do
    with_fx :reverb, mix: 0.2 do
      play_pattern_timed [:d4, :d4, :d4, :e4, :f4, :f4, :e4, :d4, :d4, :e4, :f4, :g4, :a4, :bb4, :d5, :db5, :a4, :bb4, :g4, :e5, :f5, :g5, :a5, :f5, :e5, :d5, :db5, :a4, :bb4, :a4, :g4, :a4, :g4, :f4, :e4, :d4, :db4, :a5, :bb5, :a5, :ab5, :a5, :bb5, :a5, :ab5, :a5, :d6, :a5, :a5, :a5, :ab5, :a5, :bb5, :a5, :ab5, :a5, :bb5, :a5, :ab5, :a5, :bb5, :d6, :db6, :d6, :d6, :db6, :bb5, :a5, :a5, :d5, :g5, :db6, :d6, :d5, :g5, :d6, :db6, :e5, :g5, :db6, :bb5, :a5, :d5, :g5, :d6, :d5, :f6, :e6, :d6, :bb5, :a5, :bb5, :a5],
        [0.5, 0.25, 0.5, 0.5, 0.5, 0.5, 0.5, 1.25, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.5, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 2],
        amp: 0.3, release: 1
    end
  end
end


define :prelude1 do
  in_thread {
    piano_prelude
    piano_prelude
  }
  in_thread {
    2.times {
      piano_prelude_arp
      sleep 4
    }
  }
  in_thread {
    sleep 8
    hihat
  }
  in_thread {
    2.times {
      sleep 7
      hihat_fast
    }
  }
  in_thread {
    2.times {
      sleep 7
      hihat_fast
    }
  }
  in_thread {
    sleep 4
    3.times {
      snare2
    }
  }
  in_thread {
    sleep 8
    kick1; kick2
  }
  in_thread {
    sleep 8
    bass1; bass1
  }
  in_thread {
    sleep 12
    strings_prelude2
  }
  sleep 16
end


define :prelude2 do
  in_thread {
    piano_prelude(true)
    piano_prelude(true)
  }
  in_thread {
    2.times { piano_prelude_arp }
  }
  in_thread {
    4.times { hihat }
  }
  in_thread {
    2.times { snare1; snare2 }
  }
  in_thread {
    2.times { kick1; kick2 }
  }
  in_thread {
    sleep 15
    kick_fast
  }
  in_thread {
    4.times { bass1 }
  }
  in_thread {
    strings_prelude1
    sleep 4
    strings_prelude1
    sleep 4
  }
  in_thread {
    3.times { strings_prelude2 }
    strings_drop
  }
  in_thread {
    sleep 14
    shutter
  }
  sleep 16
end


define :verse1 do
  in_thread {
    sleep 4
    3.times { hihat }
  }
  in_thread {
    4.times { bass1 }
  }
  in_thread {
    4.times { clap }
  }
  in_thread {
    2.times { snare1; snare2 }
  }
  in_thread {
    sleep 14
    piano_verse_arp
  }
  in_thread {
    sleep 2
    4.times { shutter }
  }
  sleep 16
end


define :verse2 do
  in_thread {
    sleep 4
    3.times { hihat }
  }
  in_thread {
    4.times { bass1 }
  }
  in_thread {
    4.times { clap }
  }
  in_thread {
    2.times { snare1; snare2 }
  }
  in_thread {
    sleep 14
    piano_verse_arp
  }
  in_thread {
    sleep 2
    4.times { shutter }
  }
  sleep 16
end


define :prechorus do
  in_thread {
    2.times { kick1; kick2 }
  }
  in_thread {
    2.times { snare1; snare2 }
  }
  in_thread {
    sleep 4
    3.times { hihat }
  }
  in_thread {
    4.times { clap }
  }
  in_thread {
    bass_prechorus
  }
  in_thread {
    piano_prechorus_arp
  }
  in_thread {
    sleep 14
    sample SAMPLE_DIR + "/scratch.ogg", amp: 1.5
  }
  in_thread {
    strings_prechorus
  }
  sample SAMPLE_DIR + "/crash.ogg"
  sleep 16
end


define :chorus do
  in_thread {
    4.times { kick1; kick2 }
  }
  in_thread {
    8.times { hihat }
  }
  in_thread {
    8.times { clap }
  }
  in_thread {
    4.times { snare1; snare2 }
  }
  in_thread {
    2.times { strings_chorus }
  }
  in_thread {
    bell_chorus
  }
  in_thread {
    base_chorus1
    base_chorus2
  }
  in_thread {
    sleep 28
    strings_drop
  }
  sample SAMPLE_DIR + "/crash.ogg"
  sleep 32
end


define :bridge do
  in_thread {
    2.times { kick1; kick2 }
  }
  in_thread {
    2.times { snare1; snare2 }
  }
  in_thread {
    4.times { hihat }
  }
  in_thread {
    4.times { bass1 }
  }
  in_thread {
    2.times { piano_prelude }
  }
  in_thread {
    piano_prelude_arp
  }
  in_thread {
    sleep 12
    strings_prelude2
  }
  sleep 16
end


# 前奏
prelude1; prelude2

# 主歌
verse1; verse2

# 导歌 + 副歌
prechorus; chorus

# 过渡段落
bridge

# 重复第一段内容
verse2; prechorus; chorus

# 结尾
strings_ending
