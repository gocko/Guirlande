"
I'm a visitor building a control flow from a methodNode. 





Implementation details:

ControlFlowSelectors are the selectors that are taken into account during control flow analysis.
	They are transformed and use to call associated visitMethod, ie visitIfTrueIfFalse: for ifTrue:ifFalse:
"
Class {
	#name : #GrdVisitor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'node',
		'inferer',
		'methods'
	],
	#classVars : [
		'BinarySelectors',
		'ControlFlowSelectors',
		'CoreSelectors'
	],
	#category : #Guirlande
}

{ #category : #initialization }
GrdVisitor class >> initialize [
	"self initialize"

	self initializeControlFlowSelectors.
	self initializeBinarySelectors.
	self initializeCoreSelectors 
]

{ #category : #initialization }
GrdVisitor class >> initializeBinarySelectors [
	BinarySelectors := #(#+  #-  #/  #\  #*  #~  #<  #>  #=  #@  #%  #|  #&  #?  #,)
]

{ #category : #initialization }
GrdVisitor class >> initializeControlFlowSelectors [
	"ControlFlowSelectors are the selectors that are taken into account during control flow analysis.
	They are transformed and use to call associated visitMethod, ie visitIfTrue: for ifTrue:"

	ControlFlowSelectors := #(#ifFalse: #ifTrue: #whileTrue: #whileFalse:)
]

{ #category : #accessing }
GrdVisitor >> exitNode [
	^ node exitNode
]

{ #category : #accessing }
GrdVisitor >> inferer [
	^inferer
]

{ #category : #accessing }
GrdVisitor >> inferer: anInferer [
	inferer := anInferer
]

{ #category : #initialization }
GrdVisitor >> initialize [
	super initialize.
	node := GrdChildishNode new.
	methods := Dictionary new

]

{ #category : #testing }
GrdVisitor >> isBinarySelector: aSymbol [
	"returns whether the selector should be considered as a binaryselector and handled as such"

	(aSymbol asString) do: [ :each | (BinarySelectors includes: each asSymbol ) ifFalse: [^ false]].
	^true
		
]

{ #category : #testing }
GrdVisitor >> isControlFlowSelector: aSymbol [
	"returns whether the selector should be considered as a control flow selector and handled as such"

	^ (ControlFlowSelectors includes: aSymbol)	
]

{ #category : #testing }
GrdVisitor >> isValueSelector: aSymbol [
	"returns whether the selector should be considered as a control flow selector and handled as such"

	^ ((aSymbol separateKeywords) includesSubstring: 'value')	
]

{ #category : #accessing }
GrdVisitor >> node [
	^ node
]

{ #category : #accessing }
GrdVisitor >> node: aNode [
	node := aNode
]

{ #category : #accessing }
GrdVisitor >> startNode [
	^ node startNode
]

{ #category : #utilities }
GrdVisitor >> transformSelector: aSymbol [
	"instead of doing this at runtime we can also store them because we will have some troubles with | and others"
	^ 'visit', ((($: split: aSymbol) collect: [ :each | each capitalized ]) joinUsing: ''),':'
 
]

{ #category : #visiting }
GrdVisitor >> visitAssignmentNode: aNode [
	| a variable value|
	a := GrdAssignmentNode new .
	variable := self visitNode: aNode variable.
	value := self visitNode: aNode value.
	a addChild: variable.
	a addChild: value.
	
	variable nextNode: value.
	value previousNode: variable.

	a name: 'array'.
	^ a
]

{ #category : #visiting }
GrdVisitor >> visitBinary: aNode [
	| binaryNode msgReceiver msgSelector msgArg |
	binaryNode := GrdExpressionNode new.
	msgReceiver := self visitNode: aNode receiver.
	msgArg := self visitNode: (aNode arguments) first.
	msgSelector := GrdOperatorNode new.
	msgSelector name: aNode selector.
	msgSelector value:aNode selector.
	
	binaryNode name: 'binary node'.

	msgReceiver nextNode: msgSelector.
	msgSelector previousNode: msgReceiver.
	msgSelector nextNode: msgArg.
	msgArg previousNode: msgSelector.
	
	binaryNode addChild: msgReceiver.
	binaryNode addChild: msgSelector.
	binaryNode addChild: msgArg.
	msgReceiver parent: binaryNode.
	msgSelector parent: binaryNode.
	msgArg parent: binaryNode.
	
	^ binaryNode
		msgReceiver: msgReceiver;
		msgSelector: msgSelector;
		msgArg: msgArg
]

{ #category : #visiting }
GrdVisitor >> visitBlockNode: aNode [ 

	| block blockEntryPoint |
	
	"blockEntryPoint := ((inferer typeProvider messageTypes) detect: [:messageType | messageType message = aNode body statements first]) methodType."
	block := GrdBlockNode new.
	block addChild: ( self visitBodyNode: aNode ).
	block name: 'block'.
	^ block
	
	
	
	

]

{ #category : #visiting }
GrdVisitor >> visitBlockValueNode: aValueNode [
	| valueNode |
	valueNode := GrdBlockValueNode new.
	valueNode addChild: (self visitNode: aValueNode receiver).
	aValueNode arguments do: [ :each | valueNode addChild: (self visitNode: each). ].
	valueNode name: 'value'.
	^ valueNode 
]

{ #category : #visiting }
GrdVisitor >> visitBodyNode: aNode [ 
	
	| b statements |
	
	b := GrdBodyNode new.
	statements := aNode statements.
	( statements do: [:each | (each class = RBMessageNode) 		
				ifTrue:[ b addChild: (self visitMessageNode: each)]
				ifFalse: [ b addChild: (self visitNode: each)]] ) .
	b name: 'body'.
	^ b 
]

{ #category : #visiting }
GrdVisitor >> visitBodyNode: aNode at: entryPoints [
	
	| b statements |
	
	b := GrdBodyNode new.
	statements := aNode statements.
	( statements do: [:each |  (each class = RBMessageNode) 		
				ifTrue:[ b addChild: (self visitMessageNode: each at: entryPoints)]
				ifFalse: [ b addChild: (self visitNode: each)]] ) .
	b name: 'body'.
	^ b 
]

{ #category : #visiting }
GrdVisitor >> visitCascadeNode: aCascadeNode [ 
	|childishNode|
	childishNode := GrdChildishNode new.
	aCascadeNode messages do: [:each | childishNode addChild: (self visitMessageNode: each)].
	^childishNode
]

{ #category : #'visiting control selectors' }
GrdVisitor >> visitIfFalse: aNode [
	| conditionNode cond if |
	self flag: #somewrong. "is iffalse a if branch or would not be better to have it as a elseBranch. 
	do we make the distinction."
	
	conditionNode := GrdSingleBranchNode new.
	cond := self visitNode: aNode receiver.
	if := self visitBlockNode: aNode arguments first.
	conditionNode name: 'ifFalse node'.
	
	cond nextNode: if.
	if previousNode: cond.
	
	conditionNode addChild: cond.
	conditionNode addChild: if.
	
	cond parent: conditionNode.
	if parent: conditionNode.
	
	^ conditionNode
		condition: cond;
		ifBranch: if
]

{ #category : #'visiting control selectors' }
GrdVisitor >> visitIfFalseIfTrue: aNode [

	| conditionNode cond if else |

self flag: 'we are not going to need this'.

	conditionNode := GrdIfDoubleBranchNode new.
	cond := self visitNode: aNode receiver.
	if := self visitNode: aNode arguments second.
	else := self visitNode: aNode arguments first.
	conditionNode name: 'ifFalseIfTrue node'.
		
	conditionNode addChild:cond.
	conditionNode addChild: else.
	conditionNode addChild: if.		
			
	cond nextNode: else.
	else previousNode: cond.			
	cond nextNode: if.
	if previousNode: cond.
	
	cond parent: conditionNode.
	else parent: conditionNode.
	if parent: conditionNode.

	^ conditionNode
			condition: cond;
			elseBranch: else ;
			ifBranch: if
		
]

{ #category : #'visiting control selectors' }
GrdVisitor >> visitIfTrue: aNode [
	| conditionNode cond if |
	conditionNode := GrdSingleBranchNode new.
	cond := self visitNode: aNode receiver.
	if := self visitBlockNode: aNode arguments first.
	conditionNode name: 'ifTrue node'.

	cond nextNode: if.
	if previousNode: cond.

	conditionNode addChild: cond.
	conditionNode addChild: if.
	
	cond parent: conditionNode.
	if parent: conditionNode.
	
	^ conditionNode
		condition: cond;
		ifBranch: if
]

{ #category : #'visiting control selectors' }
GrdVisitor >> visitIfTrueIfFalse: aNode [
	| conditionNode cond if else |
	
self flag: 'we are not going to need this'.

	conditionNode := GrdIfDoubleBranchNode new.
	cond := self visitNode: aNode receiver.
	if := self visitNode: aNode arguments first.
	else := self visitNode: aNode arguments second.
	conditionNode name:'ifTrueIfFalse node'.
	
	conditionNode addChild:cond.
	conditionNode addChild: if.
	conditionNode addChild: else.
	
	cond nextNode: if.
	if previousNode: cond.
	cond nextNode: else.
	else previousNode: cond.

	
	cond parent: conditionNode.
	if parent: conditionNode.
	else parent: conditionNode.
	
	^ conditionNode
		condition: cond;
		ifBranch: if;
		elseBranch: else 
]

{ #category : #visiting }
GrdVisitor >> visitLiteralArrayNode: aNode [
	| a |
	a := GrdArrayNode new value: aNode value.
	a name: 'array'.
	^ a
]

{ #category : #visiting }
GrdVisitor >> visitLiteralNode: aNode [
	| c |
	c := GrdConstantNode new value: aNode value.
	c name: 'literal'.
	^ c
]

{ #category : #visiting }
GrdVisitor >> visitMessageNode: aNode [
	| block entryPoint |

	(aNode selector = #subclassResponsibility)
		ifTrue: [ ^ GrdDesignChoiceNode new name: 'subclassResponsibility' ].

	(self isControlFlowSelector: aNode selector)
		ifTrue: [  ^ self perform: (self transformSelector: aNode selector) asSymbol with: aNode].

	(self isBinarySelector: aNode selector)
		ifTrue: [  ^ self visitBinary: aNode].

	(self isValueSelector: aNode selector) 
		ifTrue: [ ^ self visitBlockValueNode: aNode ].	

	(self isCoreSelector: aNode selector) 
		ifTrue: [ ^ GrdCoreMethodNode new name: 'core method' ]..	
	

	self flag: 'clean all these dirty places'.
	self inferer isNil ifTrue:[
		block := BlockClosure readFrom: '[',aNode sourceCode,']'.
			"to do: make inferer a singleton"
		(block isClean  ) ifTrue: [ self inferer: PhineasInferer new. self inferer infer:  block ]].
	
	entryPoint := ((inferer typeProvider messageTypes) detect: [:messageType | messageType message = aNode]) methodType .
	^self visitMessageNode: aNode at: entryPoint 
]

{ #category : #visiting }
GrdVisitor >> visitMessageNode: aNode at: entryPoint [
	| block methodsInvoked childishNode messageType |
	


	(self isControlFlowSelector: aNode selector)
		ifTrue: [  ^ self perform: (self transformSelector: aNode selector) asSymbol with: aNode].

	(self isBinarySelector: aNode selector)
		ifTrue: [  ^ self visitBinary: aNode].

	(self isValueSelector: aNode selector) 
		ifTrue: [ ^ self visitBlockValueNode: aNode ].	

	(aNode selector = #subclassResponsibility)
		ifTrue: [ ^ GrdDesignChoiceNode new name: 'subclassResponsibility' ].


	self flag: 'clean all these dirty places'.
	block := BlockClosure readFrom: '[',aNode sourceCode,']'.
			"to do: make inferer a singleton"
	(self inferer isNil & block isClean  ) ifTrue: [ self inferer: PhineasInferer new. self inferer infer:  block ].

	messageType := entryPoint getMessageType: aNode.
	methodsInvoked  := messageType methodTypes array.

	childishNode := GrdChildishNode new.
	
	(aNode isCascaded not or: [aNode isFirstCascaded]) 
		ifTrue: [ childishNode addChild: (self visitNode: aNode receiver)].
	 
	methodsInvoked do: [:each | each notNil ifTrue: [childishNode addChild: (self visitMethodNode: each node at: each) ]].			
	 
	aNode arguments do: [:each | childishNode addChild: (self visitNode: each)].
	^ childishNode


]

{ #category : #visiting }
GrdVisitor >> visitMethodNode: aMethodNode [ 
	
	| b block |
	self flag: 'clean all these dirty places'.
	block := BlockClosure readFrom: '[',aMethodNode body sourceCode,']'.
			"to do: make inferer a singleton"
	(self inferer isNil & block isClean  ) ifTrue: [ self inferer: PhineasInferer new. self inferer infer:  block ].
	
"	self halt."	
	b :=  self visitBodyNode: aMethodNode body.
	b name: 'Method ' , aMethodNode selector asString . 
	(self inferer isNil ) ifFalse: [ methods add: (self inferer entryPoints  at: 1) -> b].
	
		^ b
]

{ #category : #visiting }
GrdVisitor >> visitMethodNode: aMethodNode at: entryPoint [
	
	| b block |
		self flag: 'clean all these dirty places'.
	block := BlockClosure readFrom: '[',aMethodNode body sourceCode,']'.
	"to do: make inferer a singleton"
	(self inferer isNil ) ifTrue: [ self inferer: PhineasInferer new. self inferer infer:  block ].
	"self halt."
	(methods includesKey:  entryPoint) 
		ifTrue: [ b := methods at: entryPoint]
		ifFalse: [ 	
			b := self visitBodyNode: aMethodNode body at: entryPoint.
			b name: 'Method ' , aMethodNode selector asString . 
			methods add: entryPoint -> b
		].
	^ b 
]

{ #category : #visiting }
GrdVisitor >> visitReturnNode: aReturnNode [
	| returnNode |
	returnNode := GrdReturnNode new.
	returnNode addChild: (self visitNode: aReturnNode value).
	returnNode name: 'return' .
	^ returnNode 
]

{ #category : #visiting }
GrdVisitor >> visitVariableNode: aNode [
	| v |
	v := GrdVariableNode new value: aNode value.
	v name: 'variable'.
	^ v
]

{ #category : #'visiting control selectors' }
GrdVisitor >> visitWhileFalse: aNode [
	| loopNode collectionReceiver blockArg bodyOfBlock exitOfBody |
	
self flag: 'we are not going to need this. Replace by whileTrue'.

	loopNode := GrdLoopNode new.
	collectionReceiver := self visitNode: aNode receiver.
	blockArg := self visitBlockNode: (aNode arguments) first.
	bodyOfBlock := (blockArg children at:2).
   exitOfBody := (bodyOfBlock children at:2) nextNode .
	loopNode name: 'whileTrue node'.

	loopNode addChild: collectionReceiver.
	loopNode addChild: blockArg.
	
	collectionReceiver nextNode: blockArg.
	blockArg previousNode: collectionReceiver.
	blockArg nextNode: collectionReceiver. " povratna sprega "
	
	collectionReceiver parent: loopNode.
	blockArg parent: loopNode.
	
	^ loopNode
		
]

{ #category : #'visiting control selectors' }
GrdVisitor >> visitWhileTrue: aNode [
	| loopNode collectionReceiver blockArg bodyOfBlock exitOfBody |
	
self flag: 'we are not going to need this. Replace by whileTrue'.

	loopNode := GrdLoopNode new.
	collectionReceiver := self visitNode: aNode receiver.
	blockArg := self visitBlockNode: (aNode arguments) first.
	bodyOfBlock := (blockArg children at:2).
   exitOfBody := (bodyOfBlock children at:2) nextNode .
	loopNode name: 'whileTrue node'.

	loopNode addChild: collectionReceiver.
	loopNode addChild: blockArg.
	
	collectionReceiver nextNode: blockArg.
	blockArg previousNode: collectionReceiver.
	blockArg nextNode: collectionReceiver. " povratna sprega "
	
	collectionReceiver parent: loopNode.
	blockArg parent: loopNode.
	
	^ loopNode
		
]
