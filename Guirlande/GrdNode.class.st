Class {
	#name : #GrdNode,
	#superclass : #Object,
	#instVars : [
		'parent',
		'children',
		'nextNode',
		'name',
		'previousNodes'
	],
	#category : #Guirlande
}

{ #category : #accessing }
GrdNode >> allNodes [
| children | 

children := OrderedCollection new.
children add: self.
(self isKindOf: GrdChildishNode)
ifTrue: [ self children do: [  :each | children addAll: each allNodes] ].
^ children
]

{ #category : #accessing }
GrdNode >> children [
	^ children
]

{ #category : #testing }
GrdNode >> initialize [
	super initialize.
	name := ''.
	children := nil.
	previousNodes := OrderedCollection new.
	

]

{ #category : #testing }
GrdNode >> isExit [

	^ false
]

{ #category : #testing }
GrdNode >> isReturn [

	^ false
]

{ #category : #accessing }
GrdNode >> mergeToNode: aNode [
	
	self children isNil ifFalse: [ aNode children isNil ifTrue: [aNode children: self children] ifFalse: [  aNode children addAll: self children]].
	aNode nextNode isNil ifTrue: [ aNode nextNode: self nextNode ].
	^aNode

]

{ #category : #accessing }
GrdNode >> name [
	^ name
	
]

{ #category : #accessing }
GrdNode >> name: aName [
	name := aName
	
]

{ #category : #accessing }
GrdNode >> nextNode [
	^nextNode
]

{ #category : #accessing }
GrdNode >> nextNode: aNode [
	nextNode := aNode.
]

{ #category : #accessing }
GrdNode >> parent [
	^ parent
]

{ #category : #accessing }
GrdNode >> parent: aParentNode [

	parent := aParentNode
]

{ #category : #accessing }
GrdNode >> previousNodes [
	^previousNodes
]

{ #category : #accessing }
GrdNode >> previousNodes: aCollectionOfNodes [
	previousNodes := aCollectionOfNodes
]
