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
	
]

{ #category : #initialization }
GrdVisitor class >> initializeBinarySelectors [
	BinarySelectors := #(#+  #-  #/  #\  #*  #~  #<  #>  #=  #@  #%  #|  #&  #?  #,)
]

{ #category : #initialization }
GrdVisitor class >> initializeControlFlowSelectors [
	"ControlFlowSelectors are the selectors that are taken into account during control flow analysis.
	They are transformed and use to call associated visitMethod, ie visitIfTrue: for ifTrue:"

	ControlFlowSelectors := #(#ifFalse: #ifTrue: #ifTrue:ifFalse: #ifFalse:ifTrue: #whileTrue: #whileFalse:)
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
	value previousNodes add: variable.

	a name: ':='.
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
	
	binaryNode name: 'binary msg: ', aNode selector asString .

	msgReceiver nextNode: msgSelector.
	msgSelector previousNodes add: msgReceiver.
	msgSelector nextNode: msgArg.
	msgArg previousNodes add: msgSelector.
	
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
	
	| b statements temp|
	
	b := GrdBodyNode new.
	statements := aNode statements.
	( statements do: [:each |  (each class = RBMessageNode) 		
				ifTrue:[ 
					temp := self visitNoninferringMessageNode: each.
					temp isNil 
						ifFalse: [ b addChild: temp]
						ifTrue: [ b addChild: (self visitMessageNode: each at: entryPoints)]]
				ifFalse: [  b addChild: (self visitNode: each)]] ) .
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
	| conditionNode cond method if |
	conditionNode := GrdSingleBranchNode new.
	cond := self visitNode: aNode receiver.
	method := GrdCoreMethodNode new name: 'ifFalse:'.
	if := self visitBlockNode: aNode arguments first.
	conditionNode name: 'ifFalse: node'.

	conditionNode addChild: cond.
	conditionNode addChild: method.
	conditionNode addChild: if.
		
	^ conditionNode
]

{ #category : #'visiting control selectors' }
GrdVisitor >> visitIfFalseIfTrue: aNode [

	| conditionNode cond branchMethod if else |


	conditionNode := GrdDoubleBranchNode new.
	cond := self visitNode: aNode receiver.
	branchMethod := GrdCoreMethodNode new name: 'ifFalse:ifTrue: '.
	else := self visitNode: aNode arguments second.
	if  := self visitNode: aNode arguments first.
	conditionNode name: 'IfFalse:ifTrue: node'.
		
	conditionNode addChild:cond.
	conditionNode addChild: branchMethod.
	conditionNode addChild: else.	
	conditionNode addChild: if.	
		
		
	^ conditionNode
]

{ #category : #'visiting control selectors' }
GrdVisitor >> visitIfTrue: aNode [
	| conditionNode cond method if |
	conditionNode := GrdSingleBranchNode new.
	cond := self visitNode: aNode receiver.
	method := GrdCoreMethodNode new name: 'ifTrue:'.
	if := self visitBlockNode: aNode arguments first.
	conditionNode name: 'ifTrue: node'.

	conditionNode addChild: cond.
	conditionNode addChild: method.
	conditionNode addChild: if.
		
	^ conditionNode
		
]

{ #category : #'visiting control selectors' }
GrdVisitor >> visitIfTrueIfFalse: aNode [

	| conditionNode cond branchMethod if else |


	conditionNode := GrdDoubleBranchNode new.
	cond := self visitNode: aNode receiver.
	branchMethod := GrdCoreMethodNode new name: 'ifTrue:ifFalse: '.
	if  := self visitNode: aNode arguments first.
	else := self visitNode: aNode arguments second.
	conditionNode name: 'ifTrue:IfFalse: node'.
		
	conditionNode addChild:cond.
	conditionNode addChild: branchMethod.
	conditionNode addChild: if.	
	conditionNode addChild: else.		
		
	^ conditionNode
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
	c := GrdConstantNode new name:  aNode value asString.
	^ c
]

{ #category : #visiting }
GrdVisitor >> visitMessageNode: aNode [
	| resultNode entryPoint |

	resultNode := self visitNoninferringMessageNode: aNode.
	resultNode isNil ifFalse: [ ^ resultNode].
		
	self flag: 'clean all these dirty places'.
	self inferer isNil ifTrue:[ self inferer: PhineasInferer new. self inferer infer:  aNode ].
	
	[entryPoint := ((inferer typeProvider messageTypes) detect: [:messageType | messageType message = aNode]) methodType ]
		on: Error do: [^ GrdUndefinedMessageNode new name: 'GrdUndefinedMessageNode: ', aNode selector asString , '[exited in frist step]'].
	
	^ self visitMessageNode: aNode at: entryPoint 
]

{ #category : #visiting }
GrdVisitor >> visitMessageNode: aNode at: entryPoint [
	| methodsInvoked childishNode messageType |
	
	
	childishNode := GrdChildishNode new.
	
	(aNode isCascaded not or: [aNode isFirstCascaded]) 
		ifTrue: [ childishNode addChild: (self visitNode: aNode receiver)].

	messageType := entryPoint getMessageType: aNode.
	methodsInvoked  := messageType methodTypes. 
	methodsInvoked do: [:each | each notNil ifTrue: [childishNode addChild:  ( self visitMethodNode: each node at: each )] ].
	 "on: Error do: [:ex | childishNode addChild: (GrdUndefinedMessageNode new name: aNode selector asString)]."
	
	 
	aNode arguments do: [:each | childishNode addChild: (self visitNode: each)].
	^ childishNode


]

{ #category : #visiting }
GrdVisitor >> visitMethodNode: aMethodNode [ 
	
	| b entryPoint|
	self flag: 'clean all these dirty places. <todo: make inferer a singleton>'.
		self flag: 'should not stop when is not possible to infer. should go down in ifFalse. Ensure: ?'.	
	[(self inferer isNil ) ifTrue: [ self inferer: PhineasInferer new. self inferer infer:  aMethodNode ]] 
	ensure:[
		(self inferer entryPoints notEmpty )
			ifTrue: [ 
				entryPoint := self inferer entryPoints at: 1.
				(methods includesKey:  entryPoint ) 
					ifTrue: [ b := methods at: entryPoint]
					ifFalse: [ 
						methods add: entryPoint -> GrdChildishNode new.
						self flag: 'it can happen that we get an unbound exception here'.
						b :=  self visitBodyNode: aMethodNode body at: entryPoint .
						b name: 'Method: ' , aMethodNode selector asString . 
						(methods at: entryPoint ) mergeToNode: b.
						methods at: entryPoint put: b.
						]
					]
				ifFalse: [  
					b :=  self visitBodyNode: aMethodNode body .
					b name: 'Method: ' , aMethodNode selector asString , '[without inferer]'. 
				].
].	
		^ b
]

{ #category : #visiting }
GrdVisitor >> visitMethodNode: aMethodNode at: entryPoint [
	
	| b block |
		self flag: 'clean all these dirty places'.
	(self inferer isNil ) ifTrue: [ self inferer: PhineasInferer new. self inferer infer:  aMethodNode ].
	(methods includesKey:  entryPoint) 
		ifTrue: [  b := methods at: entryPoint]
		ifFalse: [ 	
			methods add: entryPoint -> GrdChildishNode new.
			b := self visitBodyNode: aMethodNode body at: entryPoint.
			b name: 'Method: ' , aMethodNode selector asString . 
			methods at: entryPoint put: ((methods at: entryPoint ) mergeToNode: b).
		].
	^ b 
]

{ #category : #visiting }
GrdVisitor >> visitNoninferringMessageNode: aNode [

	(aNode selector = #subclassResponsibility)
		ifTrue: [ ^ GrdDesignChoiceNode new name: 'subclassResponsibility' ].

	(self isControlFlowSelector: aNode selector)
		ifTrue: [  ^ self perform: (self transformSelector: aNode selector) asSymbol with: aNode].

	(self isBinarySelector: aNode selector)
		ifTrue: [  ^ self visitBinary: aNode].

	(self isValueSelector: aNode selector) 
		ifTrue: [ ^ self visitBlockValueNode: aNode ].	
	
	^nil
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
	v := GrdVariableNode new .
	v name: 'variable: ', aNode value asString.
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
	loopNode name: 'whileFalse: node'.

	loopNode addChild: collectionReceiver.
	loopNode addChild: (GrdCoreMethodNode new name: 'whileFalse:').
	loopNode addChild: blockArg.
	
	loopNode exitNode nextNode: loopNode startNode.
	^ loopNode
		
]

{ #category : #'visiting control selectors' }
GrdVisitor >> visitWhileTrue: aNode [
	| loopNode collectionReceiver blockArg bodyOfBlock  |

	loopNode := GrdLoopNode new.
	collectionReceiver := self visitNode: aNode receiver.
	blockArg := self visitBlockNode: (aNode arguments) first.
	bodyOfBlock := (blockArg children at:2).
	loopNode name: 'whileTrue: node'.


	loopNode addChild: collectionReceiver.
	loopNode addChild: (GrdCoreMethodNode new name: 'whileTrue:').
	loopNode addChild: blockArg.
	
	loopNode exitNode nextNode: loopNode startNode.
	^ loopNode
]
