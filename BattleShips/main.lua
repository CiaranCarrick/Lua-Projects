--Ciaran Carrick
display.setStatusBar(display.HiddenStatusBar);--Hide stat bar, obvious I know.

-- Variables for Basic Functionality
gap = 6--Gap between each tile, Increased by 1 unit
rectWidth = 50--Width of our tiles
rectHeight = 50--Height of our tiles, I could just use 1 size for tiles but chose to this method instead
gridWidth = 10--How many tiles will be printed?
gridHeight = 16--
canBuild = true -- Controls ship building fore makeShips
--
ShowMessages=false -- Helps display on start up
Messages ={} --Create Table to hold Messages

--Each time Messages is called it'll run though this array and pick out a Toast to display 
Messages.hit = {"Ship has been hit!",
		"Tis' but a scratch", 
		"That hurt!", 
		"Ouch", 
		"Try hitting us again", 
		"You'll pay for this!",
		"grr"}
--Each time Messages is called it'll run though this array and pick out a Toast to display 
Messages.whiff = {"What a scrub", 
		 "Where were you aiming?",
		 "Nice shot, jking ",
		 "pfft",
		 "Clean your glasses",
		 "Dumb and blind huh?"} 
			       
  -- Variables for Scoring
  maximumScore = (gridWidth * gridHeight)
  currentScore = maximumScore
  shipSquareCount = 0
  --SET TO 'true' to see ships on start up
  debugMode = false-- Debug Mode is to show no two ships overlap, it will also show ship placement on grid, just set to true and run
  
  -- Set position to centre,from the top left position grid_x and grid_y pos will start here
  xCentre = display.contentWidth/2
  yCentre = display.contentHeight/2
   
   -- The entire Canvas of screen with tile amount, sizes and gap per tile
  TotalscreenWidth = (gridWidth * rectWidth) +(gap * (gridWidth-3))
  TotalscreenHeight= (gridHeight * rectHeight) +(gap * (gridHeight-1)) 
  
  Xgrid = xCentre - TotalscreenWidth/2-- C
  Ygrid = yCentre - TotalscreenHeight/2--
   
   -- Aligns grid X and Y into the centre of the screen
  Xgrid = Xgrid + rectHeight/2
  Ygrid = Ygrid + rectWidth/2
  
  --Ygrid = yPos - (TotalscreenHeight/2)+rectWidth/4 Another way to display canvas
  --Xgrid = xPos - (TotalscreenWidth/2)+rectHeight/4 --
  
  rects = {} --Create empty array to store tiles
  for i = 1, gridWidth, 1 do
    rects[i] = {} --First fill with Horz tiles for following nested loop in tapped function
  end
  

  function tapped(event)
   --default feedback message and message colour
    toast = ''
    toast_color = {r=255,g=0,b=0} -- Set toast to red
    if not event.target.hasBeenTapped then   -- If tapped
       event.target.hasBeenTapped = true      -- Continue
      if event.target.ship then              -- If theres a ship
         ShowMessages=true
		 system.vibrate() --Vibrate device when enemy ship is tapped
         toast = Messages.hit[math.random(1,#Messages.hit)]
         Toast(toast, toast_color)
         event.target:setFillColor(255,0,0)    --Set white sqaure red
         shipSquareCount = shipSquareCount - 1 --decrease over ship count
      else
         Messages.text.isVisible = false--Hide toast text
         ShowMessages=false
         updateScore()-- Score starts off gridWidth * gridHeight, Each miss will decrease score value
         event.target:setFillColor(0,255,0) --Each sqaure that has no ship present will be set Green
      end
      if math.random(1,100) > 60 then -- 40% chance of showing whiff message
        if not ShowMessages then
          toast_color = {r=255,g=255,b=255}-- Set to white text
          toast = Messages.whiff[math.random(1,#Messages.whiff)] -- pick a random whiff message from 1 to array length
          Toast(toast, toast_color)
        end
        Messages.text.isVisible = true--Check for UI visibility
      end
      if shipSquareCount <= 0 then
         winScreen() 
      end
  end
 end
  
  -- Print rectangles
  for i = 1, gridWidth, 1 do
    for j = 1, gridHeight, 1 do
      -- Draws out rectangles till 126 have been printed
      rects[i][j] = display.newRect((Xgrid+(rectWidth + gap) * (i - 1)), (Ygrid +(rectHeight + gap) * (j - 1)), rectWidth, rectHeight) --Much cleaner than before
      rects[i][j]:addEventListener("tap", tapped) -- adds event to each tile needed to Recognize tap
      rects[i][j].ship = false --Set empty for default
      rects[i][j].hasBeenTapped = false
    end
  end -- End array for loop
  
  --makeShip Function
  function makeShip(shipSize)
    canBuild = true
    x = math.random(1,gridWidth)
    y = math.random(1,gridHeight)
    if debugMode then --debugMode is active all ship tiles which have notbeentapped will appear in teal
      r = math.random(0,0)
      g = math.random(0,255)--Make all ship tiles teal colour
      b = math.random(0,255)--
    end
    
    if rects[x][y].ship then
      canBuild = false
    end
    if canBuild then
      if math.random(1,2) == 1 then -- Choose to build vert (1) or horz (2)
        --Across
        if x + shipSize >= gridWidth + 1 then
          --Test Left
          for i = 1, shipSize-1, 1 do
            if rects[x-i][y].ship then
              canBuild = false
            end
          end
          --Build Left
          if canBuild then
            rects[x][y].ship = true
            shipSquareCount = shipSquareCount + 1
            if debugMode then
              rects[x][y]:setFillColor(r,g,b)
            end
            for i = 1, shipSize-1, 1 do
              rects[x-i][y].ship = true
              shipSquareCount = shipSquareCount + 1
              if debugMode then
                rects[x-i][y]:setFillColor(r,g,b)
              end
            end
          end
        else
          --Test Right
          for i = 1, shipSize-1, 1 do
            if rects[x+i][y].ship then
              canBuild = false
            end
          end
          --Build Right
          if canBuild then
            rects[x][y].ship = true
            shipSquareCount = shipSquareCount + 1
            if debugMode then
              rects[x][y]:setFillColor(r,g,b)
            end
            for i = 1, shipSize-1, 1 do
              rects[x+i][y].ship = true
              shipSquareCount = shipSquareCount + 1
              if debugMode then
                rects[x+i][y]:setFillColor(r,g,b)
              end
            end
          end
        end
      else
        --Down
        if y + shipSize >= gridHeight + 1 then
          --Test Up
          for i = 1, shipSize-1, 1 do
            if rects[x][y-i].ship then
              canBuild = false
            end
          end
          --Build Up
          if canBuild then
            rects[x][y].ship = true
            shipSquareCount = shipSquareCount + 1
            if debugMode then
              rects[x][y]:setFillColor(r,g,b)
            end
            for i = 1, shipSize-1, 1 do
              rects[x][y-i].ship = true
              shipSquareCount = shipSquareCount + 1
              if debugMode then
                rects[x][y-i]:setFillColor(r,g,b)
              end
            end
          end
        else
          --Test Down
          for i = 1, shipSize-1, 1 do
            if rects[x][y+i].ship then
              canBuild = false
            end
          end
          --Build Down
          if canBuild then
            rects[x][y].ship = true
            shipSquareCount = shipSquareCount + 1
            if debugMode then
              rects[x][y]:setFillColor(r,g,b)
            end
            for i = 1, shipSize-1, 1 do
              rects[x][y+i].ship = true
              shipSquareCount = shipSquareCount + 1
              if debugMode then
                rects[x][y+i]:setFillColor(r,g,b)
              end
            end
          end
        end
      end
    end
  
    if not canBuild then
      makeShip(shipSize)
    end
  end
  --
  makeShip(2) 
  makeShip(3) 
  makeShip(5) 
  makeShip(4) 
  
  -- Code to set up Scoring
  scoreText = display.newText("Score: "..currentScore, 0, 0, nil, 40) -- Nil shows no value, 40 indicates size
  scoreText.x = display.contentWidth/2
  scoreText.y = 40 -- Move text 40pixels down Y-axis
  scoreText:setFillColor( 1, 0, .1 )
  
  --TOASTS, messages that will display on the screen when tapped function is called, 
  --white text will be shown when empty tiles are clicked, red when a ship is present
  --
  Messages.text = display.newText({ -- Add text specifications
      x=display.contentWidth/2, -- Set from centre
      y=display.contentHeight-40, -- Bottom and 40 units up
      text="", 					  -- Set to null/nil
	  font = native.systemFont,
      fontSize=36,
      align="Center"
	  })
      
  function Toast(toast, color)
    if Messages and Messages.text and toast == '' then--Check UI
        Messages.text.isVisible = false -- Set to false by default, will need to modify if restart is built in
      else--Function has been called, set Messages to toast value
        Messages.text.text = toast
      if Messages.text.setFillColor then
        Messages.text:setFillColor(color.r/255,color.g/255,color.b/255)
      end 
      Messages.text.isVisible = true--Check for UI visibility
    end
    --Text feedback for Toast Function
  end
  --
  --
  function updateScore()
    currentScore = currentScore - 1
    scoreText.text = "Score: "..currentScore
  end
  
  function winScreen()
    -- Hide Everything
    scoreText.isVisible = false
    for i = 1, gridWidth, 1 do
      for j = 1, gridHeight, 1 do
        rects[i][j].isVisible = false
	Messages.text.isVisible=false
      end
    end
    -- Show Win Screen Stuff
    winText = display.newText("YOU WIN!", 0, 0, nil, 40)
    winText.x = display.contentWidth/2
    winText.y = display.contentHeight/3
    finalScoreText = display.newText("YOUR FINAL SCORE: "..currentScore, 0, 0, nil, 40)
    finalScoreText.x = display.contentWidth/2
    finalScoreText.y = display.contentHeight/2+80
    finalScoreText:setFillColor( 1, 0, .1 )
end
--end program