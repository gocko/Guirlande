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

	self assert: visitor node class equals: GrdBodyNode.
	self assert: visitor node startNode nextNode class equals: GrdArrayNode.	
	self assert: visitor node startNode nextNode nextNode isExit.
	
	
]

{ #category : #tests }
GuirlandeTest >> testAssignment [
	| assignmentNode|
	self visitSampleMethodNamed: #onlyAssignment.
	assignmentNode := visitor node startNode nextNode.
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
	block := visitor node startNode nextNode .
	
	self assert: visitor node class equals: GrdBodyNode.
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
	assignmentNode := visitor node startNode nextNode .
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
	blockValueNode := visitor node startNode nextNode.
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
	blockValueNode := visitor node startNode nextNode .
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
	| doNode  doBlock doMethod condition  |
	self visitSampleMethodNamed: #loopDo.
	doNode := visitor node startNode nextNode.
	condition := doNode startNode nextNode.
	doMethod := condition nextNode.
	doBlock := doMethod nextNode.

	
	self assert: doNode nextNode isExit.
	self assert: doNode class equals: GrdChildishNode.
	self assert: condition class equals: GrdArrayNode. 
	self assert: doBlock class equals: GrdBlockNode. 
	self assert: doNode children size equals: 5.
	self assert: doMethod class equals: GrdBodyNode.
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
	binaryNode := visitor node startNode nextNode startNode nextNode.
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
	binaryNode := visitor node startNode nextNode.
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
	binaryNode := visitor node startNode nextNode.
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
	binaryNode := visitor node startNode nextNode.
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
	binaryNode := visitor node startNode nextNode.
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

{ #category : #tests }
GuirlandeTest >> testFact [
	|   ifLessNode  ifLessCondition  ifLessMethod ifLessBlock factNode varNode parameterNode ifMoreNode ifMoreCondition ifMoreMethod ifMoreBlock errorNode |
	
	self flag: 'does not test the recursion'.
	
	self visitSampleMethodNamed: #fact.
	varNode := visitor node startNode nextNode startNode nextNode startNode nextNode .
	factNode := varNode nextNode.
	parameterNode := factNode nextNode.
	
	ifLessNode := factNode startNode nextNode .
	ifLessCondition := ifLessNode startNode nextNode.
	ifLessMethod := ifLessCondition nextNode.
	ifLessBlock := ifLessMethod nextNode.
	
	ifMoreNode := ifLessNode nextNode .
	ifMoreCondition := ifMoreNode startNode nextNode.
	ifMoreMethod := ifMoreCondition nextNode.
	ifMoreBlock := ifMoreMethod nextNode.
	
	errorNode := ifMoreNode nextNode.

	self assert: parameterNode nextNode isExit.
	self assert: varNode class equals: GrdVariableNode .
	self assert: factNode class equals: GrdBodyNode .
	self assert: parameterNode class equals: GrdConstantNode .
	
	self assert: errorNode nextNode isExit.
	
	self assert: ifLessNode class equals: GrdSingleBranchNode .
	self assert: ifLessCondition class equals: GrdExpressionNode. 
	self assert: ifLessBlock class equals: GrdBlockNode. 
	self assert: ifLessNode children size equals: 5.
	self assert: ifLessMethod class equals: GrdCoreMethodNode .
	
	self assert: ifMoreNode class equals: GrdSingleBranchNode.
	self assert: ifMoreCondition class equals: GrdExpressionNode. 
	self assert: ifMoreBlock class equals: GrdBlockNode. 
	self assert: ifMoreNode children size equals: 5.
	self assert: ifMoreMethod class equals: GrdCoreMethodNode.
	
	self assert: errorNode class equals: GrdChildishNode .	
	
	
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

	| doNode  condition method block singleBranchNode |

	self visitSampleMethodNamed: #justBlokIf.
	doNode := visitor node startNode nextNode.
	condition := doNode startNode nextNode .
	method := condition nextNode.
	block := method nextNode.
	singleBranchNode := block startNode nextNode startNode nextNode.
	
	self assert: visitor node class equals: GrdBodyNode.
	self assert: doNode nextNode isExit.
	self assert: doNode class equals: GrdChildishNode .
	self assert: condition class equals: GrdArrayNode. 
	self assert: method class equals: GrdBodyNode.
	self assert: block class equals: GrdBlockNode. 
	self assert: doNode children size equals: 5.
	self assert: block children size equals: 3. "GrdIfSingleBranchNode"
	self assert: block startNode nextNode children size equals: 3.
	self assert: singleBranchNode children size equals: 5.
	self assert: singleBranchNode class equals: GrdSingleBranchNode .
	self assert: (singleBranchNode startNode nextNode nextNode ) class equals: GrdCoreMethodNode  .	
	self assert: (block children at:2 ) class equals: GrdBodyNode 

]

{ #category : #tests }
GuirlandeTest >> testJustIfFalse [
	| singleBranchNode condition ifMethod ifBody|
	self visitSampleMethodNamed: #justIfFalse.
	
	singleBranchNode := visitor node startNode nextNode.
	condition := singleBranchNode startNode nextNode.
	ifMethod := condition nextNode.
	ifBody := ifMethod nextNode.
	
	self assert: visitor startNode nextNode nextNode isExit.
	self assert: singleBranchNode class equals: GrdSingleBranchNode .
	self assert: condition class equals:  GrdConstantNode.
	self assert: singleBranchNode children size equals: 5.
	self assert: ifBody children size equals: 3.
	self assert: (ifBody children at:2 ) class equals: GrdBodyNode.
	self assert: (ifBody children at:2 ) startNode nextNode class equals: GrdConstantNode 

	
]

{ #category : #tests }
GuirlandeTest >> testJustIfFalseIfTrue [
	| singleBranchNode condition ifMethod trueBlock falseBlock|
	self visitSampleMethodNamed: #justIfFalseIfTrue.
	
	singleBranchNode := visitor node startNode nextNode.
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
	self assert: (ifMethod children at:2 ) class equals: GrdDesignChoiceNode .
	self assert: trueBlock startNode nextNode class equals: GrdBodyNode.
	self assert: falseBlock startNode nextNode class equals: GrdBodyNode.
	self assert: trueBlock startNode nextNode startNode nextNode class equals: GrdConstantNode.
	self assert: falseBlock startNode nextNode startNode nextNode class equals: GrdConstantNode.
	
]

{ #category : #tests }
GuirlandeTest >> testJustIfTrue [
| condition singleBranchNode ifMethod ifBranch|
	self visitSampleMethodNamed: #justIfTrue.
	
	singleBranchNode := visitor node startNode nextNode.
	condition := singleBranchNode startNode nextNode.
	ifMethod := condition nextNode.
	ifBranch := ifMethod nextNode.
		
	self assert: singleBranchNode class equals:  GrdSingleBranchNode.
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
	| condition singleBranchNode ifBranch ifMethod |
	self visitSampleMethodNamed: #justIfTrueBlok.
	
	singleBranchNode := visitor node startNode nextNode .
	condition := singleBranchNode startNode nextNode.
	ifMethod := condition nextNode.
	ifBranch := ifMethod nextNode.
	
	self assert: singleBranchNode class equals:  GrdSingleBranchNode.
	self assert: ifBranch nextNode isExit.
	self assert: condition class equals: GrdConstantNode.
	self assert: ifBranch class equals: GrdBlockNode.
	self assert: singleBranchNode children size equals: 5.
	self assert: ifBranch children size equals: 3.
	self assert: (ifBranch children at:2) class equals: GrdBodyNode .
	self assert: (((ifBranch children) at:2 ) children at:2) class equals: GrdChildishNode.
	



















]

{ #category : #'tests-blocks' }
GuirlandeTest >> testJustIfTrueBlokIf [
	| condition singleBranchNode ifBranch ifMethod |
	self visitSampleMethodNamed: #justIfTrueBlokIf.
	
	singleBranchNode := visitor node startNode nextNode .
	condition := singleBranchNode startNode nextNode.
	ifMethod := condition nextNode.
	ifBranch := ifMethod nextNode.
	
	self assert: singleBranchNode class equals:  GrdSingleBranchNode.
	self assert: singleBranchNode nextNode isExit.
	self assert: condition class equals: GrdConstantNode.
	self assert: ifMethod class equals: GrdCoreMethodNode.
	self assert: ifBranch class equals: GrdBlockNode.
	self assert: singleBranchNode children size equals: 5.
	self assert: ifBranch children size equals: 3.
	self assert: (ifBranch children at:2) class equals: GrdBodyNode .
	self assert: ((ifBranch children at:2) children at:2) class equals: GrdChildishNode.	
	self assert: (((ifBranch children at:2) children at:2) children at:2) class equals: GrdArrayNode.
	self assert: (((ifBranch children at:2) children at:2) children at:3) class equals: GrdBodyNode .
	self assert: (((ifBranch children at:2) children at:2) children at:4)  class 	equals: GrdBlockNode .
	self assert: ((((ifBranch children at:2) children at:2) children at:4) children at:2) class 	equals: GrdBodyNode.
	self assert: (((((ifBranch children at:2) children at:2) children at:4) children at:2) children at:2) class equals: GrdSingleBranchNode.
















]

{ #category : #tests }
GuirlandeTest >> testJustIfTrueIfFalse [
	| singleBranchNode condition ifMethod trueBlock falseBlock|
	self visitSampleMethodNamed: #justIfTrueIfFalse.
	
	singleBranchNode := visitor node startNode nextNode.
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
	self assert: (ifMethod children at:2 ) class equals: GrdDesignChoiceNode.
	self assert: trueBlock startNode nextNode class equals: GrdBodyNode.
	self assert: falseBlock startNode nextNode class equals: GrdBodyNode.
	self assert: trueBlock startNode nextNode startNode nextNode class equals: GrdConstantNode.
	self assert: falseBlock startNode nextNode startNode nextNode class equals: GrdConstantNode.
	
]

{ #category : #tests }
GuirlandeTest >> testJustIfTrueInIfTrue [
| condition singleBranchNode ifMethod ifBranch|
	self visitSampleMethodNamed: #justIfTrueInIfTrue.
	
	singleBranchNode := visitor node startNode nextNode.
	condition := singleBranchNode startNode nextNode.
	ifMethod := condition nextNode.
	ifBranch := ifMethod nextNode.
	
	self assert: singleBranchNode class equals:  GrdSingleBranchNode.
	self assert: singleBranchNode nextNode isExit.
	self assert: condition class equals: GrdConstantNode.
	self assert: ifMethod class equals: GrdCoreMethodNode .
	self assert: ifBranch class equals: GrdBlockNode.
	self assert: singleBranchNode children size equals: 5.
	self assert: ifBranch children size equals: 3.
	self assert: (ifBranch children at:2 ) class equals: GrdBodyNode.
	self assert: (ifBranch children at:2 ) startNode nextNode class equals: GrdSingleBranchNode.  
	self assert: ((ifBranch children at:2 ) startNode nextNode children at: 2 ) class equals: GrdConstantNode.
	self assert: ((ifBranch children at:2 ) startNode nextNode children at: 3 ) class equals: GrdCoreMethodNode .
	self assert: ((ifBranch children at:2 ) startNode nextNode children at: 4 ) class equals: GrdBlockNode.
	
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
	childishNode := visitor node .
	self assert: childishNode class equals: GrdBodyNode.
	self assert: childishNode children size equals: 5.
	self assert: (childishNode children at:2) class equals: GrdAssignmentNode.
	self assert: (childishNode children at:3) class equals: GrdAssignmentNode.
	self assert: (childishNode children at:4) class equals: GrdChildishNode.
	self assert: ((childishNode children at:4) children at: 3) class equals: GrdBodyNode.
	self assert: (((childishNode children at:4) children at: 3) children at: 1) class equals: GrdStartNode.
	self assert: (((childishNode children at:4) children at: 3) children at: 2) class equals: GrdAssignmentNode.
	self assert: (((childishNode children at:4) children at: 3) children at: 3) class equals: GrdAssignmentNode.
	self assert: (((childishNode children at:4) children at: 3) children at: 4) class equals: GrdLoopNode.
	self assert: (((childishNode children at:4) children at: 3) children at: 5) class equals: GrdReturnNode.
	self assert: ((((childishNode children at:4) children at: 3) children at: 5) children at: 2) class equals: GrdChildishNode.
	self assert: (((childishNode children at:4) children at: 3) children at: 6) class equals: GrdExitNode.
	
]

{ #category : #'tests-utilities' }
GuirlandeTest >> testOnlyReturn [
	self visitSampleMethodNamed: #onlyReturn.
	self assert: visitor node startNode class equals: GrdStartNode.
	self assert: visitor node class equals: GrdBodyNode.
	self assert: visitor node startNode nextNode class equals: GrdReturnNode.
]

{ #category : #'tests-utilities' }
GuirlandeTest >> testOnlyReturnMessageResult [
	self visitSampleMethodNamed: #onlyReturnMessageResult.
	self assert: visitor node startNode class equals: GrdStartNode.
	self assert: visitor node class equals: GrdBodyNode.
	self assert: visitor node startNode nextNode class equals: GrdReturnNode.
	self assert: visitor node startNode nextNode startNode nextNode class equals: GrdChildishNode.	
	self assert: visitor node startNode nextNode startNode nextNode startNode nextNode class equals: GrdConstantNode .	
	self assert: visitor node startNode nextNode startNode nextNode startNode nextNode  nextNode class equals: GrdBodyNode .	
	
]

{ #category : #tests }
GuirlandeTest >> testPureReturnIfFalseIfTrue [
	| doubleBranchNode condition ifTrueBranch ifFalseBranch ifMethod|
	self visitSampleMethodNamed: #pureReturnIfFalseIfTrue.
	
	doubleBranchNode := visitor startNode nextNode children at:2.
	condition := doubleBranchNode children at: 2 .
	ifMethod := doubleBranchNode children at: 3.	
	ifTrueBranch := doubleBranchNode children at: 4.
	ifFalseBranch := doubleBranchNode children at: 5.	
		
	self assert: visitor startNode nextNode isReturn.
	self assert: visitor startNode nextNode nextNode isExit.
	self assert: doubleBranchNode class equals: GrdChildishNode.
	self assert: condition class equals:  GrdConstantNode.
	self assert: ifTrueBranch class equals:  GrdBlockNode.
	self assert: ifFalseBranch class equals:  GrdBlockNode.
	self assert: ifMethod class equals:  GrdBodyNode.
	self assert: doubleBranchNode children size equals: 6.
	self assert: condition parent class equals: GrdChildishNode.
	self assert: ifTrueBranch parent class equals: GrdChildishNode.
	self assert: ifTrueBranch children size equals: 3.
]

{ #category : #tests }
GuirlandeTest >> testPureReturnIfTrueIfFalse [
	| doubleBranchNode condition ifTrueBranch ifFalseBranch ifMethod|
	self visitSampleMethodNamed: #pureReturnIfTrueIfFalse.
	
	doubleBranchNode := visitor startNode nextNode children at:2.
	condition := doubleBranchNode children at: 2 .
	ifMethod := doubleBranchNode children at: 3.	
	ifTrueBranch := doubleBranchNode children at: 4.
	ifFalseBranch := doubleBranchNode children at: 5.	
		
	self assert: visitor startNode nextNode isReturn.
	self assert: visitor startNode nextNode nextNode isExit.
	self assert: doubleBranchNode class equals: GrdChildishNode.
	self assert: condition class equals:  GrdConstantNode.
	self assert: ifTrueBranch class equals:  GrdBlockNode.
	self assert: ifFalseBranch class equals:  GrdBlockNode.
	self assert: ifMethod class equals:  GrdBodyNode.
	self assert: doubleBranchNode children size equals: 6.
	self assert: condition parent class equals: GrdChildishNode.
	self assert: ifTrueBranch parent class equals: GrdChildishNode.
	self assert: ifTrueBranch children size equals: 3.
		
		

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
	| singleBranchNode condition ifBranch ifMethod|
	self visitSampleMethodNamed: #pureReturnOneBranch.
	
	singleBranchNode := visitor node startNode nextNode startNode nextNode.
	condition := singleBranchNode startNode nextNode .
	ifMethod := condition nextNode.
	ifBranch := ifMethod nextNode.
	
	self assert: visitor startNode nextNode isReturn.
	self assert: visitor startNode nextNode nextNode isExit.
	self assert: singleBranchNode class equals: GrdSingleBranchNode.
	self assert: condition class equals:  GrdConstantNode.
	self assert: ifBranch class equals:  GrdBlockNode.
	self assert: singleBranchNode children size equals: 5.
	self assert: condition parent class equals: GrdSingleBranchNode.
	self assert: ifBranch parent class equals: GrdSingleBranchNode.
	self assert: ifBranch children size equals: 3.
		
		
	
]

{ #category : #'tests only return' }
GuirlandeTest >> testReturnIsTheEndOfControlFlow [
		
	self visitSampleMethodNamed: #onlyReturn.
	self assert: visitor node class equals: GrdBodyNode.
	self assert: visitor node startNode nextNode nextNode isExit 
	
	
]

{ #category : #'tests-utilities' }
GuirlandeTest >> testTransformSelector [

	self assert: (visitor transformSelector: #ifTrue:ifFalse:) equals: #visitIfTrueIfFalse:.
	self assert: (visitor transformSelector: #ifTrue:) equals: #visitIfTrue:.
	
]

{ #category : #tests }
GuirlandeTest >> testVisitWhileFalse [

	| loopNode  loopBody  condition loopMethod |

	self flag: 'adapt for whileTrue: and whileFalse: , in a place of selector add GrdCoreMethodNode'.

	self visitSampleMethodNamed: #whileFalse.
	loopNode := visitor startNode nextNode nextNode nextNode.
	condition := loopNode startNode nextNode.
	loopMethod := condition nextNode .
	loopBody := loopMethod nextNode.

	
	self assert: visitor node children size equals: 6.
	self assert: loopNode class equals: GrdLoopNode .
	self assert: condition class equals: GrdBlockNode . 
	self assert: loopMethod class equals: GrdCoreMethodNode . 	
	self assert: loopBody class equals: GrdBlockNode. 
	self assert: loopNode children size equals: 5.
	self assert: loopBody parent class equals: GrdLoopNode.
	self assert: loopNode exitNode nextNode equals: loopNode startNode .
]

{ #category : #tests }
GuirlandeTest >> testVisitWhileTrue [

	| loopNode  loopBody  condition loopMethod |

	self flag: 'adapt for whileTrue: and whileFalse: , in a place of selector add GrdCoreMethodNode'.

	self visitSampleMethodNamed: #whileTrue.
	loopNode := visitor startNode nextNode nextNode nextNode.
	condition := loopNode startNode nextNode.
	loopMethod := condition nextNode .
	loopBody := loopMethod nextNode.

	
	self assert: visitor node children size equals: 6.
	self assert: loopNode class equals: GrdLoopNode .
	self assert: condition class equals: GrdBlockNode . 
	self assert: loopMethod class equals: GrdCoreMethodNode . 	
	self assert: loopBody class equals: GrdBlockNode. 
	self assert: loopNode children size equals: 5.
	self assert: loopBody parent class equals: GrdLoopNode.
	self assert: loopNode exitNode nextNode equals: loopNode startNode .
]

{ #category : #'tests-utilities' }
GuirlandeTest >> testVisitorIsWorking [
	self visitSampleMethodNamed: #onlyReturn.
	self assert: visitor node startNode class equals: GrdStartNode.
	self assert: visitor node class equals: GrdBodyNode.
	self assert: ({ GrdStartNode . GrdBodyNode . GrdReturnNode . GrdExitNode } includes: visitor startNode nextNode class ) ""
]

{ #category : #initialization }
GuirlandeTest >> visitSampleMethodNamed: aSymbol [

	
	visitor node: (visitor visitMethodNode: (GrdSample >> aSymbol) ast).

]
