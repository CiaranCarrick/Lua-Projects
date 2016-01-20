--Ciaran Carrick assignment, Any copy pasta in your work You'll fail, no exceptions.
display.setStatusBar(display.HiddenStatusBar);--Hide stat bar, obvious I know.

-- Variables for Basic Functionality
gap = 10
rectWidth = 50
rectHeight = 50
gridWidth = 10
gridHeight = 16
canBuild = true 

-- Variables for Scoring
maximumScore = gridWidth * gridHeight
currentScore = maximumScore
shipSquareCount = 0

debugMode = true -- Debug Mode is to show no two ships overlap, it will also show ship placement on grid, just set to true and run

-- Set position to centre
xPos = display.contentWidth/2
yPos = display.contentHeight/2
 
 -- The entire Canvas of screen
TotalscreenWidth = (gridWidth * rectWidth/2) +((rectWidth/2+gap) * (gridWidth-1)) 
TotalscreenHeight= (gridHeight * rectHeight/2) +((rectHeight/2+gap) * (gridHeight-1)) 

Xgrid = xPos - TotalscreenWidth/2-- If remove comments on line 34 remove lines 31-32, code will work fine
Ygrid = yPos - TotalscreenHeight/2--
 
 -- Aligns grid X and Y into the centre of the screen, RectGap/2 gaps each rectangle by quarter of Rectsize size (12.5)
Xgrid = Xgrid + rectHeight/4
Ygrid = Ygrid + rectWidth/4

--Ygrid = yPos - (TotalscreenHeight/2)+rectWidth/4 Another way to display canvas
--Xgrid = xPos - (TotalscreenWidth/2)+rectHeight/4 --


rects = {}
for i = 1, gridWidth, 1 do
	rects[i] = {}
end

function tapped(event)
	if not event.target.hasBeenTapped then -- If tapped
		event.target.hasBeenTapped = true -- Continue
		if event.target.ship then	-- If theres a ship
			event.target:setFillColor(255,0,0) --Set white sqaure red
			shipSquareCount = shipSquareCount - 1 --decrease over ship count
			if shipSquareCount <= 0 then
				winScreen() 
			end
		else
			updateScore()-- Your score starts off gridWidth * gridHeight, Each miss will decrease score valu
			event.target:setFillColor(0,255,0) --Each sqaure that has no ship present will be set Green
		end
	end
end

-- Print rectangles
for i = 1, gridWidth, 1 do
	for j = 1, gridHeight, 1 do
		-- Draws out rectangles till 126 have been printed
		rects[i][j] = display.newRect((Xgrid+(gap*i) +(i*rectWidth)-rectWidth-gap), (Ygrid+(gap*j) +(j*rectHeight)-rectWidth-gap), rectWidth, rectHeight)
		 -- Recognizes tap
		rects[i][j]:addEventListener("tap", tapped)
		rects[i][j].ship = false
		rects[i][j].hasBeenTapped = false
	end
end -- End array for loop

function makeShip(shipSize)
	canBuild = true
	x = math.random(1,gridWidth)
	y = math.random(1,gridHeight)
	if debugMode then
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

makeShip(2) --Create X sized ship, call more functions to add ships, Issues arise if you trie build >5 ships, it may crash upon load from makeShip method
makeShip(3) 
makeShip(5) 
makeShip(5) 

-- Code to set up Scoring
scoreText = display.newText("Score: "..currentScore, 0, 0, nil, 40) -- Nil shows no value, 40 indicates size
scoreText.x = display.contentWidth/2
scoreText.y = 30 -- Move text 40pixels down Y-axis
scoreText:setFillColor( 1, 0, .5 )

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
		end
	end
	-- Show Win Screen Stuff
	winText = display.newText("YOU WIN!", 0, 0, nil, 40)
	winText.x = display.contentWidth/2
	winText.y = display.contentHeight/3
	finalScoreText = display.newText("YOUR FINAL SCORE: "..currentScore, 0, 0, nil, 40)
	finalScoreText.x = display.contentWidth/2
	finalScoreText.y = display.contentHeight/2+80
	finalScoreText:setFillColor( 1, 0, .5 )
end