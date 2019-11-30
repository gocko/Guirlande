Class {
	#name : #GuirlandeTest,
	#superclass : #TestCase,
	#instVars : [
		'visitor'
	],
	#category : #Guirlande
}

{ #category : #initialization }
GuirlandeTest >> setUp [
	super setUp.
	visitor := GrdVisitor new.
]

{ #category : #tests }
GuirlandeTest >> testArray [

	self visitSampleMethodNamed: #onlyArray.

	self assert: visitor startNode nextNode class equals: GrdBodyNode.
	self assert: visitor startNode nextNode nextNode isExit.
	
self assert: visitor startNode nextNode startNode nextNode class equals: GrdArrayNode.	
	
]

{ #category : #tests }
GuirlandeTest >> testAssignment [
	| assignmentNode|
	self visitSampleMethodNamed: #onlyAssignment.
	assignmentNode := visitor startNode nextNode startNode nextNode.
	self assert: assignmentNode class equals: GrdAssignmentNode.
	self assert: assignmentNode children size equals: 4.
	self assert: (assignmentNode children at:2) class equals: GrdVariableNode.
	self assert: (assignmentNode children at:3) class equals: GrdConstantNode.
	self assert: visitor startNode nextNode nextNode isExit.
	
	
	
]

{ #category : #'tests-blocks' }
GuirlandeTest >> testBlock [
	|block|
	self visitSampleMethodNamed: #block2.
	block := visitor node startNode nextNode startNode nextNode.
	
	self assert: visitor node startNode nextNode class equals: GrdBodyNode.
	self assert: block class equals: GrdBlockNode.
	self assert: (block children at:2 )class equals: GrdBodyNode.
	self assert: block startNode nextNode nextNode class equals: GrdExitNode.
	self assert: block nextNode class equals: GrdExitNode.
	self assert: block children size equals: 3.
	self assert: ((block children at:2) children at: 2) class equals: GrdExpressionNode.
	"self assert: (block children at:2) parent class equals: GrdBodyNode."
	self assert: (((block children at:2) children at: 2) children at: 1) class equals: GrdExpressionNode.
	self assert: (((block children at:2) children at: 2) children at: 2) class equals: GrdOperatorNode.
	self assert: (((block children at:2) children at: 2) children at: 3) class equals: GrdVariableNode.
	self assert: ((((block children at:2) children at: 2) children at: 1) children at: 1) class equals: GrdVariableNode.
	self assert: ((((block children at:2) children at: 2) children at: 1) children at: 2) class equals: GrdOperatorNode.
	self assert: ((((block children at:2) children at: 2) children at: 1) children at: 1) class equals: GrdVariableNode.
]

{ #category : #'tests-blocks' }
GuirlandeTest >> testBlokAssignment [
	| assignmentNode block body constant|
	self visitSampleMethodNamed: #blokAssignment.
	assignmentNode := visitor startNode nextNode children at:2.
	block := assignmentNode children at:3.
	body := block children at:2.
	constant := body children at:2.
	
	self assert: assignmentNode class equals: GrdAssignmentNode.
	self assert: assignmentNode children size equals: 4.
	self assert: (assignmentNode children at:2) class equals: GrdVariableNode.
	self assert: visitor startNode nextNode nextNode isExit.
	self assert: block class equals: GrdBlockNode .
	self assert: body class equals: GrdBodyNode .
	self assert: constant class equals: 	GrdConstantNode .
]

{ #category : #'tests-blocks' }
GuirlandeTest >> testBlokMoreValues [
	|blockValueNode block body expression constant1 constant2|
	self visitSampleMethodNamed: #blokMoreValues.
	blockValueNode := visitor startNode nextNode startNode nextNode.
	block := blockValueNode children at:2.
	body := block children at: 2.
	constant1 := blockValueNode children at:3.
	constant2 := blockValueNode children at:4.
	expression := body children at:2 .
	
	self assert: visitor node class equals: GrdBodyNode.
	self assert: blockValueNode class equals: GrdBlockValueNode.
	self assert: blockValueNode children size equals: 5.
	self assert: (blockValueNode children at:2) class equals: GrdBlockNode.
	self assert: block class equals: GrdBlockNode.
	self assert: constant1 class equals: GrdConstantNode.
	self assert: constant2 class equals: GrdConstantNode.
	self assert: body class equals: GrdBodyNode.
	self assert: expression class equals: GrdExpressionNode.
	

	

	
	
]

{ #category : #'tests-blocks' }
GuirlandeTest >> testBlokValue2 [
	|blockValueNode block body expression constant|
	self visitSampleMethodNamed: #blok2Value.
	blockValueNode := visitor node startNode nextNode startNode nextNode.
	block := blockValueNode children at:2.
	body := block children at: 2.
	constant := blockValueNode children at:3.
	expression := body children at:2 .
	
	self assert: blockValueNode class equals: GrdBlockValueNode.
	self assert: visitor node class equals: GrdBodyNode.
	self assert: blockValueNode children size equals: 4.
	self assert: block class equals: GrdBlockNode.
	self assert: constant class equals: GrdConstantNode.
	self assert: body class equals: GrdBodyNode.
	self assert: expression class equals: GrdExpressionNode.
	
]

{ #category : #tests }
GuirlandeTest >> testCascade [
	| childisNode firstMethod secondMethod firstMethod2c firstMethod3c firstMethod4c secondMethod2c secondMethod3c|
	self visitSampleMethodNamed: #onlyCascadeStatement.
	childisNode := visitor startNode nextNode.
	firstMethod := childisNode children at:2.
	firstMethod2c := firstMethod children at:2.
	firstMethod3c := firstMethod children at:3.
	firstMethod4c := firstMethod children at:4.
	secondMethod := childisNode children at:3.
	secondMethod2c := secondMethod children at:2.
	secondMethod3c := secondMethod children at:3.
	
	self assert: visitor startNode nextNode nextNode isExit.
	self assert: childisNode class equals: GrdChildishNode.
	self assert: childisNode children size equals:4.
	self assert: firstMethod class equals: GrdChildishNode.
	self assert: firstMethod children size equals: 5.
	self assert: firstMethod2c class equals: GrdVariableNode.
	self assert: firstMethod3c class equals: GrdVariableNode.
	self assert: firstMethod4c class equals: GrdArrayNode.
	self assert: secondMethod class equals: GrdChildishNode.
	self assert: secondMethod children size equals: 4.
	self assert: secondMethod2c class equals: GrdVariableNode.
	self assert: secondMethod3c class equals: GrdArrayNode.
]

{ #category : #tests }
GuirlandeTest >> testDo [
	| doBranchNode  doBranch  condition  |
	self visitSampleMethodNamed: #loopDo.
	doBranchNode := visitor startNode nextNode.
	doBranch := doBranchNode doBranch .
	condition := doBranchNode condition.

	
	self assert: visitor startNode nextNode nextNode isExit.
	self assert: doBranchNode class equals: GrdDoNode.
	self assert: condition class equals: GrdArrayNode. 
	self assert: doBranch class equals: GrdBlockNode. 
	self assert: doBranchNode children size equals: 2.
	self assert: doBranch parent class equals: GrdDoNode.
	
]

{ #category : #'tests-blocks' }
GuirlandeTest >> testExampleNew [
	| chNode1 chNode2 chNode3 chNode4|
	self visitSampleMethodNamed: #exampleNew.
	chNode1 := visitor startNode nextNode.
	chNode2 := chNode1 nextNode.
	chNode3 := chNode2 nextNode.
	chNode4 := chNode3 nextNode.
	self assert: chNode1 class equals: GrdChildishNode.
	self assert: chNode1 children size equals: 3.
	self assert: (chNode1 children at:2) class equals: GrdChildishNode.
	self assert: ((chNode1 children at:2) children at: 2 )class equals: GrdConstantNode.
	self assert: chNode2 class equals: GrdChildishNode.
	self assert: chNode2 children size equals:3.
	self assert: (chNode2 children at:2) class equals: GrdExpressionNode.
	self assert: (chNode2 children at:2) children size equals: 3.
	self assert: ((chNode2 children at:2) children at:1) class equals: GrdChildishNode.
	self assert: ((chNode2 children at:2) children at:1) children size equals: 3.	
	self assert: ((chNode2 children at:2) children at:1) nextNode class equals: GrdOperatorNode.
	self assert: ((chNode2 children at:2) children at:1) nextNode nextNode class equals: GrdChildishNode.
	self assert: ((chNode2 children at:2) children at:1) nextNode nextNode children size equals: 3.
	self assert: chNode3 class equals: GrdChildishNode.
	self assert: chNode3 children size equals:3.
	self assert: (chNode3 children at:2) class equals: GrdChildishNode.
	self assert: (chNode3 children at:2) children size equals: 3.
	self assert: chNode4 children size equals:4.
	self assert: (chNode4 children at:2) class equals: GrdChildishNode.
	self assert: (chNode4 children at:3) class equals: GrdBlockNode.



]

{ #category : #'tests-expressions' }
GuirlandeTest >> testExpressionAddition [
	| binaryNode  msgArg  msgReceiver msgSelector |
	self visitSampleMethodNamed: #addition.
	binaryNode := visitor startNode nextNode startNode nextNode startNode nextNode.
	msgArg := binaryNode msgArg .
	msgReceiver := binaryNode msgReceiver.
	msgSelector := binaryNode msgSelector.
	
	self assert: visitor startNode nextNode nextNode isExit.
	self assert: binaryNode class equals: GrdExpressionNode.
	self assert: msgReceiver class equals: GrdConstantNode. 
	self assert: msgSelector class equals: GrdOperatorNode.
	self assert: msgSelector value equals: #+.
	self assert: msgArg class equals: GrdConstantNode. 
	self assert: binaryNode children size equals: 3.
	self assert: msgArg parent class equals: GrdExpressionNode. 

]

{ #category : #'tests-expressions' }
GuirlandeTest >> testExpressionAnd [
	| binaryNode  msgArg  msgReceiver msgSelector |
	self visitSampleMethodNamed: #and.
	binaryNode := visitor startNode nextNode startNode nextNode.
	msgArg := binaryNode msgArg .
	msgReceiver := binaryNode msgReceiver.
	msgSelector := binaryNode msgSelector.
	
	self assert: visitor startNode nextNode nextNode isExit.
	self assert: binaryNode class equals: GrdExpressionNode.
	self assert: msgReceiver class equals: GrdConstantNode. 
	self assert: msgSelector class equals: GrdOperatorNode.
	self assert: msgSelector value equals: #&.
	self assert: msgArg class equals: GrdConstantNode. 
	self assert: binaryNode children size equals: 3.
	self assert: msgArg parent class equals: GrdExpressionNode. 

]

{ #category : #'tests-expressions' }
GuirlandeTest >> testExpressionConcatenationString [
	| binaryNode  msgArg  msgReceiver  msgSelector |
	self visitSampleMethodNamed: #concatenationString.
	binaryNode := visitor startNode nextNode.
	msgArg := binaryNode msgArg .
	msgReceiver := binaryNode msgReceiver.
	msgSelector := binaryNode msgSelector.
	
	self assert: visitor startNode nextNode nextNode isExit.
	self assert: binaryNode class equals: GrdExpressionNode.
	self assert: msgReceiver class equals: GrdConstantNode. 
	self assert: msgSelector class equals: GrdOperatorNode.
	self assert: msgSelector value equals: #,.
	self assert: msgArg class equals: GrdConstantNode. 
	self assert: binaryNode children size equals: 3.
	self assert: msgArg parent class equals: GrdExpressionNode. 

]

{ #category : #'tests-expressions' }
GuirlandeTest >> testExpressionMultiplication [
	| binaryNode  msgArg  msgReceiver  msgSelector |
	self visitSampleMethodNamed: #multiplication.
	binaryNode := visitor startNode nextNode startNode nextNode.
	msgArg := binaryNode msgArg .
	msgReceiver := binaryNode msgReceiver.
	msgSelector := binaryNode msgSelector.
	
	self assert: visitor startNode nextNode nextNode isExit.
	self assert: binaryNode class equals: GrdExpressionNode.
	self assert: msgReceiver class equals: GrdConstantNode. 
	self assert: msgSelector class equals: GrdOperatorNode.
	self assert: msgSelector value equals: #*.
	self assert: msgArg class equals: GrdConstantNode. 
	self assert: binaryNode children size equals: 3.
	self assert: msgArg parent class equals: GrdExpressionNode. 

]

{ #category : #'tests-expressions' }
GuirlandeTest >> testExpressionSubtraction [
	| binaryNode  msgArg  msgReceiver  msgSelector |
	self visitSampleMethodNamed: #subtraction.
		binaryNode := visitor startNode nextNode startNode nextNode.
	msgArg := binaryNode msgArg .
	msgReceiver := binaryNode msgReceiver.
	msgSelector := binaryNode msgSelector.
	
	self assert: visitor startNode nextNode nextNode isExit.
	self assert: binaryNode class equals: GrdExpressionNode.
	self assert: msgReceiver class equals: GrdConstantNode. 
	self assert: msgSelector class equals: GrdOperatorNode.
	self assert: msgSelector value equals: #-.
	self assert: msgArg class equals: GrdConstantNode. 
	self assert: binaryNode children size equals: 3.
	self assert: msgArg parent class equals: GrdExpressionNode. 
]

{ #category : #'tests-bodynode' }
GuirlandeTest >> testInsertNodes [
	| b col |
	b := GrdBodyNode new.
	col := { GrdConstantNode new value: 1 . GrdConstantNode new value: 2 }.
	b insertChildren: col.
	self assert: b startNode nextNode equals: col first.
	self assert: col second nextNode equals: b exitNode.
	self assert: b startNode nextNode previousNode equals: b startNode.
	self assert: col second previousNode equals: col first.  
]

{ #category : #'tests-blocks' }
GuirlandeTest >> testJustBlockIf [

	| doBranchNode  blockArg  collectionReceiver bodyOfBlock  |

	self visitSampleMethodNamed: #justBlokIf.
	doBranchNode := visitor startNode nextNode.
	blockArg := doBranchNode doBranch .
	collectionReceiver := doBranchNode condition.
	bodyOfBlock := blockArg children at:2.
	
	self assert: visitor node class equals: GrdBodyNode.
	self assert: visitor startNode nextNode nextNode isExit.
	self assert: doBranchNode class equals: GrdDoNode.
	self assert: collectionReceiver class equals: GrdArrayNode. 
	self assert: blockArg class equals: GrdBlockNode. 
	self assert: doBranchNode children size equals: 2.
	self assert: blockArg parent class equals: GrdDoNode.
	self assert: collectionReceiver parent class equals: GrdDoNode.
	self assert: bodyOfBlock children size equals: 3. "GrdIfSingleBranchNode"
self assert: (bodyOfBlock children at:2 ) class equals: GrdIfSingleBranchNode.

]

{ #category : #tests }
GuirlandeTest >> testJustIfFalse [
	| singleBranchNode condition ifMethod ifBody|
	self visitSampleMethodNamed: #justIfFalse.
	
	singleBranchNode := visitor startNode nextNode startNode nextNode.
	condition := singleBranchNode startNode nextNode.
	ifMethod := condition nextNode.
	ifBody := ifMethod nextNode.
	
	self assert: visitor startNode nextNode nextNode isExit.
	self assert: singleBranchNode class equals: GrdChildishNode.
	self assert: condition class = GrdConstantNode.
	self assert: ifMethod class = GrdBodyNode.
	"self assert: ifMethod name = 'ifTrue:'."
	self assert: singleBranchNode children size equals: 5.
	self assert: ifMethod children size equals: 3.
		
	self assert: (ifMethod children at:2) class equals: GrdChildishNode .
	
	
]

{ #category : #tests }
GuirlandeTest >> testJustIfFalseIfTrue [
	| singleBranchNode condition ifMethod trueBlock falseBlock|
	self visitSampleMethodNamed: #justIfFalseIfTrue.
	
	singleBranchNode := visitor startNode nextNode startNode nextNode.
	condition := singleBranchNode startNode nextNode.
	ifMethod := condition nextNode.
	falseBlock := ifMethod nextNode.
	trueBlock := falseBlock nextNode.
	
	
	self assert: singleBranchNode class equals:  GrdChildishNode.
	self assert: singleBranchNode nextNode isExit.
	self assert: condition class equals: GrdConstantNode.
	self assert: ifMethod class equals: GrdBodyNode.
	self assert: trueBlock class equals: GrdBlockNode.
	self assert: falseBlock class equals: GrdBlockNode.	
	self assert: singleBranchNode children size equals: 6.
	self assert: ifMethod children size equals: 3.
	self assert: (ifMethod children at:2 ) class equals: GrdChildishNode.
	self assert: trueBlock startNode nextNode class equals: GrdBodyNode.
	self assert: falseBlock startNode nextNode class equals: GrdBodyNode.
	self assert: trueBlock startNode nextNode startNode nextNode class equals: GrdConstantNode.
	self assert: falseBlock startNode nextNode startNode nextNode class equals: GrdConstantNode.
	
]

{ #category : #tests }
GuirlandeTest >> testJustIfTrue [
| condition singleBranchNode ifMethod ifBranch|
	self visitSampleMethodNamed: #justIfTrue.
	
	singleBranchNode := visitor startNode nextNode startNode nextNode.
	condition := singleBranchNode children at: 2.
	ifMethod := singleBranchNode children at: 3.
	ifBranch := singleBranchNode children at: 4.
	
	self assert: singleBranchNode class equals:  GrdChildishNode.
	self assert: singleBranchNode nextNode isExit.
	self assert: condition class equals: GrdConstantNode.
	self assert: ifBranch class equals: GrdBlockNode.
	self assert: singleBranchNode children size equals: 5.
	self assert: ifBranch children size equals: 3.
	self assert: (ifBranch children at:2 ) class equals: GrdBodyNode.
	self assert: (ifBranch children at:2 ) startNode nextNode class equals: GrdConstantNode 
	
	
]

{ #category : #'tests-blocks' }
GuirlandeTest >> testJustIfTrueBlok [
	| condition singleBranchNode ifBranch|
	self visitSampleMethodNamed: #justIfTrueBlok.
	
	singleBranchNode := visitor startNode nextNode .
	condition := singleBranchNode children first.
	ifBranch := singleBranchNode ifBranch.
	
	self assert: singleBranchNode class equals:  GrdIfSingleBranchNode.
	self assert: singleBranchNode nextNode isExit.
	self assert: condition class equals: GrdConstantNode.
	self assert: ifBranch class equals: GrdBlockNode.
	self assert: singleBranchNode children size equals: 2.
	self assert: ifBranch parent class equals: GrdIfSingleBranchNode.
	self assert: condition parent class equals: GrdIfSingleBranchNode.
	self assert: ifBranch children size equals: 3.
	self assert: (ifBranch children at:2) class equals: GrdBodyNode .
	self assert: (ifBranch children at:2)  parent class equals: GrdBlockNode.
	self assert: (((ifBranch children) at:2 ) children at:2) class equals: 	GrdDoNode.
	



















]

{ #category : #'tests-blocks' }
GuirlandeTest >> testJustIfTrueBlokIf [
	| condition singleBranchNode ifBranch|
	self visitSampleMethodNamed: #justIfTrueBlokIf.
	
	singleBranchNode := visitor startNode nextNode .
	condition := singleBranchNode children first.
	ifBranch := singleBranchNode ifBranch.
	
	self assert: singleBranchNode class equals:  GrdIfSingleBranchNode.
	self assert: singleBranchNode nextNode isExit.
	self assert: condition class equals: GrdConstantNode.
	self assert: ifBranch class equals: GrdBlockNode.
	self assert: singleBranchNode children size equals: 2.
	self assert: ifBranch parent class equals: GrdIfSingleBranchNode.
	self assert: condition parent class equals: GrdIfSingleBranchNode.
	self assert: ifBranch children size equals: 3.
	self assert: (ifBranch children at:2) class equals: GrdBodyNode .
	self assert:  (ifBranch children at:2) parent class equals: GrdBlockNode .

	self assert:  ((ifBranch children at:2) children at:2) class equals: 	GrdDoNode.
	
	self assert:  (((ifBranch children at:2) children at:2) children at:1) class 	equals: GrdArrayNode.

	self assert:  (((ifBranch children at:2) children at:2) children at:2)  class 	equals: GrdBlockNode .

self assert:  ((((ifBranch children at:2) children at:2) children at:2) children at:2) class 	equals: GrdBodyNode.
			
	self assert: (((((ifBranch children at:2) children at:2) children at:2) children at:2) children at:2) class equals: GrdIfSingleBranchNode.
















]

{ #category : #tests }
GuirlandeTest >> testJustIfTrueIfFalse [
	| singleBranchNode condition ifMethod trueBlock falseBlock|
	self visitSampleMethodNamed: #justIfTrueIfFalse.
	
	singleBranchNode := visitor startNode nextNode startNode nextNode.
	condition := singleBranchNode startNode nextNode.
	ifMethod := condition nextNode.
	trueBlock := ifMethod nextNode.
	falseBlock := trueBlock nextNode.
	
	
	self assert: singleBranchNode class equals:  GrdChildishNode.
	self assert: singleBranchNode nextNode isExit.
	self assert: condition class equals: GrdConstantNode.
	self assert: ifMethod class equals: GrdBodyNode.
	self assert: trueBlock class equals: GrdBlockNode.
	self assert: falseBlock class equals: GrdBlockNode.	
	self assert: singleBranchNode children size equals: 6.
	self assert: ifMethod children size equals: 3.
	self assert: (ifMethod children at:2 ) class equals: GrdChildishNode.
	self assert: trueBlock startNode nextNode class equals: GrdBodyNode.
	self assert: falseBlock startNode nextNode class equals: GrdBodyNode.
	self assert: trueBlock startNode nextNode startNode nextNode class equals: GrdConstantNode.
	self assert: falseBlock startNode nextNode startNode nextNode class equals: GrdConstantNode.
	
]

{ #category : #'tests only return' }
GuirlandeTest >> testMethodControlFlowHasAnExitNode [

	self visitSampleMethodNamed: #onlyReturn.
	self assert: visitor exitNode isExit


]

{ #category : #tests }
GuirlandeTest >> testOnlyMethod [
	| childishNode   |
	self visitSampleMethodNamed: #onlyMethod.
	childishNode := visitor node startNode nextNode.
	self assert: childishNode class equals: GrdBodyNode.
	self assert: childishNode children size equals: 5.
	self assert: (childishNode children at:2) class equals: GrdAssignmentNode.
	self assert: (childishNode children at:3) class equals: GrdAssignmentNode.
	self assert: (childishNode children at:4) class equals: GrdChildishNode.
	self assert: ((childishNode children at:4) children at: 3) class equals: GrdBodyNode.
	self assert: (((childishNode children at:4) children at: 3) children at: 1) class equals: GrdStartNode.
	self assert: (((childishNode children at:4) children at: 3) children at: 2) class equals: GrdAssignmentNode.
	self assert: (((childishNode children at:4) children at: 3) children at: 3) class equals: GrdAssignmentNode.
	self assert: (((childishNode children at:4) children at: 3) children at: 4) class equals: GrdChildishNode.
	self assert: (((childishNode children at:4) children at: 3) children at: 5) class equals: GrdReturnNode.
	self assert: ((((childishNode children at:4) children at: 3) children at: 5) children at: 2) class equals: GrdChildishNode.
	self assert: (((childishNode children at:4) children at: 3) children at: 6) class equals: GrdExitNode.
	
]

{ #category : #'tests-utilities' }
GuirlandeTest >> testOnlyReturn [
	self visitSampleMethodNamed: #onlyReturn.
	self assert: visitor startNode class equals: GrdStartNode.
	self assert: visitor startNode nextNode class equals: GrdBodyNode.
	self assert: visitor startNode nextNode startNode nextNode class equals: GrdReturnNode.
]

{ #category : #'tests-utilities' }
GuirlandeTest >> testOnlyReturnMessageResult [
	self visitSampleMethodNamed: #onlyReturnMessageResult.
	self assert: visitor startNode class equals: GrdStartNode.
	self assert: visitor startNode nextNode class equals: GrdBodyNode.
	self assert: visitor startNode nextNode startNode nextNode class equals: GrdReturnNode.
	self assert: visitor startNode nextNode startNode nextNode startNode nextNode class equals: GrdChildishNode.	
	self assert: visitor startNode nextNode startNode nextNode startNode nextNode startNode nextNode class equals: GrdBodyNode.	
	
	
]

{ #category : #tests }
GuirlandeTest >> testPureOneBranch [
	| condition singleBranchNode ifMethod ifBranch|
	self visitSampleMethodNamed: #justIfTrue.
	
	singleBranchNode := visitor startNode nextNode startNode nextNode.
	condition := singleBranchNode children at: 2.
	ifMethod := singleBranchNode children at: 3.
	ifBranch := singleBranchNode children at: 4.
	
	self assert: singleBranchNode class equals:  GrdChildishNode.
	self assert: singleBranchNode nextNode isExit.
	self assert: condition class equals: GrdConstantNode.
	self assert: ifBranch class equals: GrdBlockNode.
	self assert: singleBranchNode children size equals: 5.
	self assert: ifBranch children size equals: 3.
	self assert: (ifBranch children at:2 ) class equals: GrdBodyNode.
	self assert: (ifBranch children at:2 ) startNode nextNode class equals: GrdConstantNode 
	
	
]

{ #category : #tests }
GuirlandeTest >> testPureReturnIfFalseIfTrue [
	| doubleBranchNode ifBranch elseBranch condition|
	self visitSampleMethodNamed: #pureReturnIfFalseIfTrue.
	
	doubleBranchNode := visitor startNode nextNode children at:2.
	ifBranch := doubleBranchNode ifBranch .
	elseBranch := doubleBranchNode elseBranch.
	condition := doubleBranchNode condition.

	self assert: visitor startNode nextNode isReturn.
	self assert: visitor startNode nextNode nextNode isExit.
	self assert: doubleBranchNode class equals: GrdIfDoubleBranchNode.
	self assert: (condition class = GrdConstantNode). 
	self assert: (ifBranch class = GrdBlockNode). 
	self assert: (elseBranch class = GrdBlockNode). 
	self assert: doubleBranchNode children size equals: 3.
	self assert: ifBranch parent class equals: GrdIfDoubleBranchNode.
	self assert: elseBranch parent class equals: GrdIfDoubleBranchNode.
	
	self assert: ifBranch children size equals: 3.
	self assert: elseBranch children size equals: 3.
	
	self assert: (ifBranch children at:2) class equals: GrdBodyNode.
	self assert: (elseBranch children at:2) class equals: GrdBodyNode .
		
	self assert: (ifBranch children at:2) parent class equals: GrdBlockNode.
	self assert: (elseBranch children at:2)parent class equals: GrdBlockNode.
]

{ #category : #tests }
GuirlandeTest >> testPureReturnIfTrueIfFalse [
	| doubleBranchNode  ifBranch elseBranch condition|
	self visitSampleMethodNamed: #pureReturnIfTrueIfFalse.
	doubleBranchNode := visitor startNode nextNode children at:2.
	ifBranch := doubleBranchNode ifBranch .
	elseBranch := doubleBranchNode elseBranch.
	condition := doubleBranchNode condition.

	self assert: visitor startNode nextNode isReturn.
	self assert: visitor startNode nextNode nextNode isExit.
	self assert: doubleBranchNode class equals: GrdIfDoubleBranchNode.
	self assert: (condition class = GrdConstantNode). 
	self assert: (ifBranch class = GrdBlockNode). 
	self assert: (elseBranch class = GrdBlockNode). 
	self assert: doubleBranchNode children size equals:3.
	self assert: ifBranch parent class equals: GrdIfDoubleBranchNode.
	self assert: elseBranch parent class equals: GrdIfDoubleBranchNode.
	
	self assert: ifBranch children size equals: 3.
	self assert: elseBranch children size equals: 3.
	
		
	self assert: (ifBranch children at:2 ) class equals: GrdBodyNode.
	self assert: (elseBranch children at:2 )class equals: GrdBodyNode.
	
	self assert: (ifBranch children at:2 )  parent class equals: GrdBlockNode .
	self assert: (elseBranch children at:2 )parent class equals: GrdBlockNode .
]

{ #category : #tests }
GuirlandeTest >> testPureReturnIfTrueIfFalseSimpleCheck [
	self visitSampleMethodNamed: #pureReturnIfTrueIfFalse.
	self assert: visitor startNode nextNode isReturn.
	self assert: visitor startNode nextNode nextNode isExit.
	self assert: visitor exitNode previousNode equals: visitor startNode nextNode 
]

{ #category : #tests }
GuirlandeTest >> testPureReturnOneBranch [
	| singleBranchNode condition ifBranch|
	self visitSampleMethodNamed: #pureReturnOneBranch.
	
	singleBranchNode := visitor startNode nextNode children at:2.
	condition := singleBranchNode condition.
	ifBranch := singleBranchNode ifBranch.
	
	self assert: visitor startNode nextNode isReturn.
	self assert: visitor startNode nextNode nextNode isExit.
	self assert: singleBranchNode class equals: GrdIfSingleBranchNode.
	self assert: condition class = GrdConstantNode.
	self assert: ifBranch class = GrdBlockNode.
	self assert: singleBranchNode children size equals: 2.
	self assert: condition parent class equals: GrdIfSingleBranchNode.
	self assert: ifBranch parent class equals: GrdIfSingleBranchNode.
	self assert: ifBranch children size equals: 3.
		
	self assert: (ifBranch children at:2) class equals: GrdBodyNode .
	self assert: (ifBranch children at:2) parent class equals: GrdBlockNode .
	
	
]

{ #category : #'tests only return' }
GuirlandeTest >> testReturnIsTheEndOfControlFlow [
		
	self visitSampleMethodNamed: #onlyReturn.
	self assert: visitor startNode nextNode class equals: GrdBodyNode.
	self assert: visitor startNode nextNode nextNode isExit 
	
	
]

{ #category : #'tests-utilities' }
GuirlandeTest >> testTransformSelector [

	self assert: (visitor transformSelector: #ifTrue:ifFalse:) equals: #visitIfTrueIfFalse:.
	self assert: (visitor transformSelector: #ifTrue:) equals: #visitIfTrue:.
	
]

{ #category : #'tests-utilities' }
GuirlandeTest >> testVisitorIsWorking [
	self visitSampleMethodNamed: #onlyReturn.
	self assert: visitor startNode class equals: GrdStartNode.
	self assert: visitor startNode nextNode class equals: GrdBodyNode.
	self assert: ({ GrdStartNode . GrdBodyNode . GrdReturnNode . GrdExitNode } includes: visitor startNode nextNode class ) ""
]

{ #category : #initialization }
GuirlandeTest >> visitSampleMethodNamed: aSymbol [

	
	visitor node: (visitor visitMethodNode: (GrdSample >> aSymbol) ast).

]
