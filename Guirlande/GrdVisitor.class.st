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
		'node'
	],
	#classVars : [
		'BinarySelectors',
		'ControlFlowSelectors'
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
	They are transformed and use to call associated visitMethod, ie visitIfTrueIfFalse: for ifTrue:ifFalse:"

	ControlFlowSelectors := #(#ifTrue:ifFalse: #ifFalse:ifTrue: #ifFalse: #ifTrue: #do:)
]

{ #category : #accessing }
GrdVisitor >> exitNode [
	^ node exitNode
]

{ #category : #initialization }
GrdVisitor >> initialize [
	super initialize.
	node := GrdBodyNode new.

]

{ #category : #testing }
GrdVisitor >> isBinarySelector: aSymbol [
	"returns whether the selector should be considered as a binaryselector and handled as such"

	^ (BinarySelectors includes: aSymbol)	
]

{ #category : #testing }
GrdVisitor >> isControlFlowSelector: aSymbol [
	"returns whether the selector should be considered as a control flow selector and handled as such"

	^ (ControlFlowSelectors includes: aSymbol)	
]

{ #category : #testing }
GrdVisitor >> isValueSelector: aSymbol [
	"returns whether the selector should be considered as a control flow selector and handled as such"


	^ ((aSymbol separateKeywords) includesSubstring: 'value:')	
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

	| block body |
	
	block := GrdBlockNode new.
	body:= (GrdVisitor new) visitBodyNode: aNode body.
	"block insertNode: body."
	block addChild: body.
	body parent: block.
	block name: 'block'.
	
	"value := self visitNode: aNode arguments first."
	
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
	
	| b |
	b := GrdBodyNode new.
	b insertChildren: (aNode statements collect: [:each | (self visitNode: each) ]).
	b name: 'body'.
	^ b
]

{ #category : #visiting }
GrdVisitor >> visitCascadeNode: aCascadeNode [ 
	|childishNode|
	childishNode := GrdChildishNode new.
	aCascadeNode messages do: [:each | childishNode addChild: (self visitNode: each)].
	^childishNode
]

{ #category : #'visiting control selectors' }
GrdVisitor >> visitDo: aNode [
	| loopNode collectionReceiver blockArg bodyOfBlock exitOfBody |
	loopNode := GrdDoNode new.
	collectionReceiver := self visitNode: aNode receiver.
	blockArg := self visitBlockNode: (aNode arguments) first.
	bodyOfBlock := (blockArg children at:2).
   exitOfBody := (bodyOfBlock children at:2) nextNode .
	loopNode name: 'do node'.

	loopNode addChild: collectionReceiver.
	loopNode addChild: blockArg.
	
	collectionReceiver nextNode: blockArg.
	blockArg previousNode: collectionReceiver.
	blockArg nextNode: collectionReceiver. " povratna sprega "
	
	
	
	collectionReceiver parent: loopNode.
	blockArg parent: loopNode.
	
	^ loopNode
		condition: collectionReceiver;
		doBranch: blockArg
]

{ #category : #'visiting control selectors' }
GrdVisitor >> visitIfFalse: aNode [
	| conditionNode cond if |
	self flag: #somewrong. "is iffalse a if branch or would not be better to have it as a elseBranch. 
	do we make the distinction."
	
	conditionNode := GrdIfSingleBranchNode new.
	cond := self visitNode: aNode receiver.
	if := self visitNode: aNode arguments first.
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
	conditionNode := GrdIfSingleBranchNode new.
	cond := self visitNode: aNode receiver.
	if := self visitNode: aNode arguments first.
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
	| childishNode|

	(self isControlFlowSelector: aNode selector)
		ifTrue: [  ^ self perform: (self transformSelector: aNode selector) asSymbol with: aNode].

	(self isBinarySelector: aNode selector)
		ifTrue: [  ^ self visitBinary: aNode].

	(self isValueSelector: aNode selector) 
		ifTrue: [ ^ self visitBlockValueNode: aNode ].
	
			
	childishNode := GrdChildishNode new.	
	(aNode isCascaded not or: [aNode isFirstCascaded]) 
		ifTrue: [ childishNode addChild: (self visitNode: aNode receiver)].
	aNode arguments do: [:each | childishNode addChild: (self visitNode: each)].
	^ childishNode


]

{ #category : #visiting }
GrdVisitor >> visitMethodNode: aMethodNode [ 
	
	|inferer entries b methods messages statements childishNode|
	inferer := PhineasInferer new.
	messages := OrderedCollection new.
	methods := OrderedCollection new.
	inferer infer:  (BlockClosure readFrom: '[',aMethodNode body sourceCode,']') .
	entries := inferer entryPoints.
	( entries collect: [:aMethodType| aMethodType messagesTypes]) do: [:each | messages addAll: each].
	( messages collect:[:aMessageType| aMessageType methodTypes ]) do: [:each | methods addAll: each].
	
	statements := aMethodNode body statements.
		
	b := GrdBodyNode new.
	(statements do: [:each |  (each class = RBMessageNode) 		
				ifTrue:[childishNode := GrdChildishNode new. (messages select: [ :any | any message = each ]) do: [:all | all methodTypes do: [ :method| childishNode addChild: (self visitMethodNode: method node with: inferer from: method). b addChild: childishNode]]]
				ifFalse: [b addChild: (self visitNode: each)]]).
	b name: 'method name'.
	^ b 
]

{ #category : #visiting }
GrdVisitor >> visitMethodNode: aMethodNode with: anInferer from: entryPoints [
	
	| entries b methods messages statements childishNode|
	messages := OrderedCollection new.
	methods := OrderedCollection new.
	entries := entryPoints. "have to move entry points"
	entries messagesTypes do: [:each | messages add: each].
	( messages collect:[:aMessageType| aMessageType methodTypes ]) do: [:each | methods addAll: each].
	
	statements := aMethodNode body statements.
		
	b := GrdBodyNode new.
	
	( statements do: [:each |  (each class = RBMessageNode) 		
				ifTrue:[childishNode := GrdChildishNode new. (messages select: [ :any | any message = each ]) do: [:all | all methodTypes do: [ :method| childishNode addChild: (self visitMethodNode: method node with: anInferer from: method)]]. b addChild: childishNode]
				ifFalse: [b addChild: (self visitNode: each)]] ) .
	b name: 'method name'.
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
