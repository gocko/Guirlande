Class {
	#name : #GrdChildishNode,
	#superclass : #GrdNode,
	#instVars : [
		'children'
	],
	#category : #Guirlande
}

{ #category : #accessing }
GrdChildishNode >> addChild: aNode [

	self exitNode previousNode nextNode: aNode.
	aNode nextNode: self exitNode.
	aNode previousNode: self exitNode previousNode.
	self exitNode previousNode: aNode.
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
	startNode nextNode: exitNode.
	exitNode previousNode: startNode.
	children addFirst: startNode. 
	children addLast: exitNode.
	
]

{ #category : #'as yet unclassified' }
GrdChildishNode >> insertChildren: listOfNodes [
	listOfNodes do: [:each | self addChild: each ].
	
	
]

{ #category : #'as yet unclassified' }
GrdChildishNode >> startNode [

	^ children first 
	
]
