$numberOfSpins = 10_000_000

$stops = [0, 0, 0, 0, 0]

$view = [
  [' ', ' ', ' ', ' ', ' '],
  [' ', ' ', ' ', ' ', ' '],
  [' ', ' ', ' ', ' ', ' '],
  [' ', ' ', ' ', ' ', ' '],
  [' ', ' ', ' ', ' ', ' '],
]

$freeGames = 0;

$numberOfBaseGames = 0;

$numberOfBaseFreeGames = 0;

$numberOfFreeFreeGames = 0;

$baseBonusCount = 0;

$freeBonusCount = 0;

$baseFreeActivationCount = 0;

$freeFreeActivationCount = 0;

$baseRegularWon = 0;

$baseBonusWon = 0;

$baseLost = 0;

$freeRegularWon = 0;

$freeBonusWon = 0;

$scatterBaseWon = 0;

$scatterFreeWon = 0;

$totalWon = 0;

$totalLost = 0;

$payouts =[ [ 0, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, 0 ], [ 0, 0, 0, 0, 0, 0 ],
  [ 100, 5, 10, 50, 100, 5 ], [ 250, 10, 50, 100, 150, 10 ], [ 500, 50, 100, 200, 250, 50 ], ]

$strips = [  [ 'B', 'C', 'A', 'C', 'A', 'W', 'A', 'A', 'C', 'A', 'D', 'C', 'B', 'B', 'S', 'C', 'A', 'C', 'C', 'B', 'A',
  'D', 'B', 'C', 'D', 'B', 'C', 'A', 'B', 'A', 'B', ],
  [ 'A', 'W', 'B', 'A', 'B', 'A', 'D', 'C', 'B', 'S', 'C', 'C', 'A', 'B', 'A', 'A', 'A', 'A', 'D', 'A', 'C',
  'B', 'D', 'B', 'B', 'A', 'C', 'A', 'A', 'A', 'A', ],
  [ 'D', 'B', 'A', 'B', 'D', 'B', 'D', 'A', 'B', 'C', 'S', 'A', 'D', 'B', 'A', 'W', 'B', 'A', 'D', 'A', 'A',
  'A', 'D', 'B', 'A', 'C', 'A', 'C', 'D', 'D', 'D', ],
  [ 'D', 'A', 'A', 'B', 'D', 'B', 'C', 'B', 'A', 'D', 'A', 'A', 'D', 'D', 'W', 'A', 'D', 'B', 'C', 'B', 'C',
  'B', 'C', 'B', 'S', 'C', 'A', 'D', 'A', 'A', 'D', ],
  [ 'C', 'A', 'A', 'W', 'A', 'A', 'B', 'A', 'C', 'B', 'S', 'A', 'A', 'C', 'C', 'B', 'B', 'B', 'D', 'B', 'B',
  'A', 'D', 'A', 'C', 'C', 'D', 'B', 'D', 'A', 'B', ], ]

def print() 
  for j in 0..4
    for i in 0..4
      printf $view[i][j]
      printf " "
    end
    printf "\n"
  end
end

def spin()
  for i in 0..4
    r = rand($strips[i].length)
    for j in 0..4
      $view[i][j] = $strips[i][(r + j) % $strips[i].length]
    end
  end
end

def wildLineWin(index)
  count = 0
  for i in 0..4
    if $view[i][index] == 'W'
      count = count + 1
    end
  end

  return $payouts[count][0]
end

def lineWin(index) 
  symbol = $view[0][index]

  win = 0;
  if symbol == 'W'
    win = wildLineWin(index)
    for i in 0..4
      if $view[i][index] != 'W' 
        symbol = $view[i][index]
        break
      end
    end
  end

  if symbol == 'W' 
    return win
  end

  count = 0
  for i in 0..4
    if $view[i][index] == symbol 
      count = count + 1
    elsif $view[i][index] == 'W' 
      count = count + 1
    else 
      break;
    end
  end
  
  case symbol
  when 'W'
    return [$payouts[count][0], win].max
  when 'A'
    return [$payouts[count][1], win].max
  when 'B'
    return [$payouts[count][2], win].max
  when 'C'
    return [$payouts[count][3], win].max
  when 'D'
    return [$payouts[count][4], win].max
  end

  return 0
end

def linesWin() 
  result = 0

  for j in 0..4
    result = result + lineWin(j)
  end

  return result
end

def scatterWin() 
  count = 0;

  for i in 0..4
    for j in 0..4
      if $view[i][j] == 'S' 
        count = count + 1
      end
    end
  end

  return $payouts[count][5]
end

def numberOfFreeGames() 
  count = 0

  for i in 0..4
    for j in 0..4
      if $view[i][j] == 'S' 
        count = count + 1
      end
    end
  end

  case count
  when 3
    return 5
  when 4
    return 10
  when 5
    return 20
  end

  return 0
end

def hasX() 
  symbol = $view[0][0]

  for i in 0..4
    if $view[i][i] != symbol 
      return false
    end
    if $view[i][$view.length - i - 1] != symbol 
      return false
    end
  end

  return true
end

def replace()
  symbol = $view[0][0]

  case $view[0][0]
  when 'A'
    symbol = 'B'
  when 'B'
    symbol = 'C'
  when 'C'
    symbol = 'D'
  when 'D'
    symbol = 'W'
  end

  for i in 0..4
    $view[i][i] = symbol
    $view[i][$view.length - i - 1] = symbol
  end
end

def initStatistics() 
  $numberOfBaseGames = 0
  $numberOfBaseFreeGames = 0
  $numberOfFreeFreeGames = 0
  $baseBonusCount = 0
  $freeBonusCount = 0
  $baseFreeActivationCount = 0
  $freeFreeActivationCount = 0
  $baseRegularWon = 0
  $baseBonusWon = 0
  $baseLost = 0
  $freeRegularWon = 0
  $freeBonusWon = 0
  $scatterBaseWon = 0
  $scatterFreeWon = 0
  $totalWon = 0
  $totalLost = 0
end

def printStatistics() 
  printf "\n"
  printf "Bonus games in base game:\t"
  printf "%f", 100.0 * $baseBonusCount / $numberOfBaseGames

  printf "\n"
  printf "Bonus games in free games:\t"
  printf "%f", 100.0 * $freeBonusCount / ($numberOfBaseFreeGames + $numberOfFreeFreeGames)

  printf "\n"
  printf "Free games frequency in base game:\t"
  printf "%f", 100.0 * $baseFreeActivationCount / $numberOfBaseGames

  printf "\n"
  printf "Free games frequency in free games:\t"
  printf "%f", 100.0 * $freeFreeActivationCount / $numberOfBaseFreeGames

  printf "\n"
  printf "Won by regular lines in base game:\t"
  printf "%f", 100.0 * $baseRegularWon / $totalLost

  printf "\n"
  printf "Won by bonus lines in base game:\t"
  printf "%f", 100.0 * $baseBonusWon / $totalLost

  printf "\n"
  printf "Won by regular lines in free games:\t"
  printf "%f", 100.0 * $freeRegularWon / $totalLost

  printf "\n"
  printf "Won by bonus lines in free games:\t"
  printf "%f", 100.0 * $freeBonusWon / $totalLost

  printf "\n"
  printf "Won by scatters in base game:\t"
  printf "%f", 100.0 * $scatterBaseWon / $totalLost

  printf "\n"
  printf "Won by scatters in free games:\t"
  printf "%f", 100.0 * $scatterFreeWon / $totalLost

  printf "\n"
  printf "Total RTP:\t"
  printf "%f", 100.0 * $totalWon / $totalLost
  
  printf "\n"
end

def monteCarlo() 
  initStatistics();

  win1 = 0;
  win2 = 0;
  for g in 0..$numberOfSpins-1
    $numberOfBaseGames = + 1
    $baseLost += 5
    $totalLost += 5
    spin()
    win1 = linesWin()
    win2 = scatterWin()
    $baseRegularWon += win1
    $scatterBaseWon += 5 * win2
    $totalWon += win1 + 5 * win2

#    
#    Check for free games.
#    
    $freeGames = numberOfFreeGames()
    if $freeGames > 0 
      $numberOfBaseFreeGames += $freeGames
      $baseFreeActivationCount = $baseFreeActivationCount + 1
    end

#    
#     Handle X bonus.
#    
    if hasX() == true 
#      
#       Scatter win is counted only once and no extra free spins
#       added.
#      
      replace()
      win1 = linesWin()
      $baseBonusWon += win1
      $totalWon += win1
      $baseBonusCount = $baseBonusCount + 1
    end

#    
#     Free games mode.
#     
    while $freeGames > 0 
      spin()
      win1 = linesWin()
      win2 = scatterWin()
      $freeRegularWon += win1
      $scatterFreeWon += 5 * win2
      $totalWon += win1 + 5 * win2

      $freeGames = $freeGames - 1
      count = numberOfFreeGames()
      if count > 0
        $numberOfFreeFreeGames += count
        $freeFreeActivationCount = $freeFreeActivationCount + 1
      end
      $freeGames += count

      if hasX() == true 
#        
#        Scatter win is counted only once and no extra free spins
#        added.
#        
        replace()
        win1 = linesWin()
        $freeBonusWon += win1
        $totalWon += win1
        $freeBonusCount = $freeBonusCount + 1
      end
    end
  end

  printStatistics()
end

def nextScreen() 
  for i in 0..4
    for j in 0..4
      $view[i][j] = $strips[i][($stops[i] + j) % $strips[i].length];
    end
  end
end

def nextCombination() 
  $stops[$stops.length - 1] = $stops[$stops.length - 1] + 1
  for i in $stops.length - 1..1
    if $stops[i] > $strips[i].length 
      $stops[i - 1] = $stops[i - 1] + 1
      $stops[i] = 0
    end
  end
end

def bruteForce() 
  initStatistics()

  $stops = [ 0, 0, 0, 0, 0 ]

  numberOfCombinations = 1;
  for i in 0..4
    numberOfCombinations *= $strips[i].length
  end

  win1 = 0;
  win2 = 0;
  for g in 0..numberOfCombinations-1
    nextScreen()

    $numberOfBaseGames = $numberOfBaseGames + 1 
    $baseLost += 5
    $totalLost += 5
    win1 = linesWin()
    win2 = scatterWin();
    $baseRegularWon += win1
    $scatterBaseWon += 5 * win2
    $totalWon += win1 + 5 * win2

#    
#     Check for free games.
#    
    $freeGames = numberOfFreeGames()
    if $freeGames > 0 
      $numberOfBaseFreeGames += $freeGames
      $baseFreeActivationCount = $baseFreeActivationCount + 1 
    end

    if hasX() == true 
#      
#        Scatter win is counted only once and no extra free spins
#        added.
#       
      replace()
      win1 = linesWin()
      $baseBonusWon += win1
      $totalWon += win1
      $baseBonusCount = $baseBonusCoun + 1
    end

    nextCombination()
  end

  printStatistics()
end

printf "=== Monte Carlo ===\n"
monteCarlo()

printf "=== Brute Force ==="
bruteForce()
