Class {
	#name : #GrdReturnNode,
	#superclass : #GrdChildishNode,
	#category : #Guirlande
}

{ #category : #testing }
GrdReturnNode >> expression [

	^ children first
]

{ #category : #testing }
GrdReturnNode >> isReturn [ 

	^ true
]
