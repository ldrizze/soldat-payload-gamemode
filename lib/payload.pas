Unit Payload;

interface
    type TOnPlayerCollision = procedure (Player: TActivePlayer; Side: Byte);
    type
        TPayload = record
        	xVel: single;
        	velStep: single;
        	velMax: single;
        	isMoving: boolean;
            isContested: boolean;
            Collider: CollisionBox;
            ExternalCollider: CollisionBox;
            OnPlayerCollision, OnPlayerExternalCollision: TOnPlayerCollision;
        end;
implementation
end.