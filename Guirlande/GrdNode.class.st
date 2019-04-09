Class {
	#name : #GrdNode,
	#superclass : #Object,
	#instVars : [
		'rawNode',
		'parent',
		'nextNode',
		'previousNode',
		'name'
	],
	#category : #Guirlande
}

{ #category : #testing }
GrdNode >> isExit [

	^ false
]

{ #category : #testing }
GrdNode >> isReturn [

	^ false
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
GrdNode >> previousNode [
	^ previousNode
]

{ #category : #accessing }
GrdNode >> previousNode: aNode [
	previousNode := aNode
]

{ #category : #accessing }
GrdNode >> rawNode [
	^ rawNode
]

{ #category : #accessing }
GrdNode >> rawNode: aProgramNode [

	rawNode := aProgramNode
]
