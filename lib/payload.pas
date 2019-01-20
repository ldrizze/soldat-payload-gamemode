Unit Payload;

interface
    type TOnPlayerCollision = procedure (Player: TActivePlayer; Side: Byte);
    type
        TPayload = record
            Collider: CollisionBox;
            X,Y: single;
            OnPlayerCollision: TOnPlayerCollision;
        end;
implementation
end.