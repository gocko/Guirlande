Class {
	#name : #GrdChildishNode,
	#superclass : #GrdNode,
	#category : #Guirlande
}

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

{ #category : #accessing }
GrdChildishNode >> mergeToNode: aNode [
	
	children isNil ifFalse: [ aNode children isNil ifTrue: [aNode children: self children] ifFalse: [  aNode children addAll: self children]].
	aNode parent: self parent.
	parent children at: (parent children find: self) put: aNode.
	aNode nextNode isNil ifTrue: [ aNode nextNode: self nextNode ].
	aNode previousNodes addAll: self previousNodes.
	^aNode
]

{ #category : #'as yet unclassified' }
GrdChildishNode >> startNode [

	^ children first 
	
]
