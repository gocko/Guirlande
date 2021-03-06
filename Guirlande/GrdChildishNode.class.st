Class {
	#name : #GrdChildishNode,
	#superclass : #GrdNode,
	#category : #Guirlande
}

{ #category : #'as yet unclassified' }
GrdChildishNode >> addAll: listOfNodes [
	listOfNodes  do:  [:each | ((each class = GrdStartNode)  or: [each class = GrdExitNode ]) ifFalse: [ self addChild: each ] ].
	
	
]

{ #category : #'as yet unclassified' }
GrdChildishNode >> addAllNodesTo: kids [

super addAllNodesTo: kids. 
self children do: [:aKid| (aKid unproperNode or: [kids includes: aKid]) ifFalse: [aKid addAllNodesTo: kids] ].
^ kids
]

{ #category : #accessing }
GrdChildishNode >> addChild: aNode [
self flag: 'maybe can have two previous nodes'.

	self exitNode previousNodes do: [ :each | each nextNode: aNode].
	aNode nextNode: self exitNode.
	aNode previousNodes removeAll addAll: self exitNode previousNodes.
	self exitNode previousNodes removeAll add: aNode.
	aNode parent: self startNode parent.
	children add: aNode before: self exitNode.
	
	


]

{ #category : #accessing }
GrdChildishNode >> children [
	^ children
]

{ #category : #accessing }
GrdChildishNode >> children: anObject [
	children := anObject
]

{ #category : #accessing }
GrdChildishNode >> collectThisLevelNodes [
	| col temp |
	col := OrderedCollection new.
	temp := self startNode.
	[temp isKindOf: GrdExitNode] whileFalse: [ col add: temp. temp := temp nextNode ].
	col add: temp.
	^ col

]

{ #category : #'as yet unclassified' }
GrdChildishNode >> exitNode [
	^ children last
]

{ #category : #accessing }
GrdChildishNode >> initialize [
	super initialize.
	children := OrderedCollection new.
	self initializeStartExit.
]

{ #category : #'as yet unclassified' }
GrdChildishNode >> initializeStartExit [

	| startNode exitNode |
	
	startNode := GrdStartNode new.
	exitNode := GrdExitNode new.
	startNode parent: self.
	exitNode parent: self.
	startNode nextNode: exitNode.
	exitNode previousNodes add: startNode.
	children addFirst: startNode. 
	children addLast: exitNode.
	
]

{ #category : #'as yet unclassified' }
GrdChildishNode >> insertChildren: listOfNodes [
	listOfNodes do:  [:each | self addChild: each ].
	
	
]

{ #category : #'as yet unclassified' }
GrdChildishNode >> isEmpty [
	^ self children size = 2 and: [self children second class = GrdExitNode]
]

{ #category : #accessing }
GrdChildishNode >> mergeToNode: aNode [
	
	aNode isEmpty
		ifFalse:[	self addChild: aNode ].
		
	
]

{ #category : #accessing }
GrdChildishNode >> mergeWithNode: aNode [
	
	children isNil ifFalse: [ aNode children isNil ifTrue: [aNode children: children] ifFalse: [  aNode addAll: self children]].
	aNode nextNode isNil ifTrue: [ aNode nextNode: nextNode ].
	aNode previousNodes addAll: self previousNodes.
	aNode parent: self parent.
	"aNode parent addChild: aNode."
	^aNode
]

{ #category : #'as yet unclassified' }
GrdChildishNode >> startNode [

	^ children first 
	
]
